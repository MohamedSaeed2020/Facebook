import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook/layouts/home_layout.dart';
import 'package:facebook/models/message_model.dart';
import 'package:facebook/models/post_model.dart';
import 'package:facebook/models/user_model.dart';
import 'package:facebook/modules/chats/chats_screen.dart';
import 'package:facebook/modules/feeds/feeds_screen.dart';
import 'package:facebook/modules/posts/new_post_screen.dart';
import 'package:facebook/modules/settings/setting_screen.dart';
import 'package:facebook/shared/components/components.dart';
import 'package:facebook/shared/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:facebook/cubits/home/facebook_state.dart';
import 'package:image_picker/image_picker.dart';

class FacebookCubit extends Cubit<FacebookStates> {
  //variables
  UserModel? user;
  int currentIndex = 0;
  List<Widget> screens = [
    const FeedsScreen(),
    const ChatsScreen(),
    NewPostScreen(),
    const SettingScreen(),
  ];
  List<String> titles = [
    'Home',
    'Chats',
    'Posts',
    'Settings',
  ];
  File? profileImage;
  File? coverImage;
  File? postImage;
  var picker = ImagePicker();
  List<PostModel> posts = [];
  List<String> postsIds = [];
  List<int> noOfLikes = [];
  List<UserModel> users = [];
  List<MessageModel> messages = [];

  //init state
  FacebookCubit() : super(FacebookInitialState());

  //get instance of the bloc
  static FacebookCubit get(context) {
    return BlocProvider.of(context);
  }

  //get user data
  void getUserData() {
    emit(FacebookGetUserLoadingState());
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .get()
        .then((value) {
          print('UserID: $userId');
      if (value.data() != null) {
        print('User Data: ${value.data()}');
        user = UserModel.fromJson(value.data());
        print('User Phone: ${user!.phone}');
        emit(FacebookGetUserSuccessState());
      }
    }).catchError((error) {
      print('Error: ${error.toString()}');
      emit(FacebookGetUserErrorState(error.toString()));
    });
  }

  //change bottom navigation index
  void changeBottomNavigation(int index) {
    if (index == 1) {
      getAllUsers();
    }
    if (index == 2) {
      emit(FacebookAddNewPostState());
    } else {
      currentIndex = index;
      emit(FacebookChangeBottomNavigationState());
    }
  }

  //pick profile image from gallery
  void getProfileImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        profileImage = File(pickedFile.path);
        emit(FacebookProfileImagePickedSuccessState());
      } else {
        print('Error In Picking The Profile Image');
        emit(FacebookProfileImagePickedErrorState());
      }
    } catch (error) {
      print('Exception In Picking The Profile Image: $error');
    }
  }

  //pick cover image from gallery
  void getCoverImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        coverImage = File(pickedFile.path);
        emit(FacebookCoverImagePickedSuccessState());
      } else {
        print('Error In Picking The Cover Image');
        emit(FacebookCoverImagePickedErrorState());
      }
    } catch (error) {
      print('Exception In Picking The Cover Image: $error');
    }
  }

  //upload profile image to storage
  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    if (profileImage != null) {
      emit(FacebookUserProfileImageUpdateLoadingState());
      FirebaseStorage.instance
          .ref()
          .child('Users/${Uri
          .file(profileImage!.path)
          .pathSegments
          .last}')
          .putFile(profileImage!)
          .then((value) {
        value.ref.getDownloadURL().then((url) {
          //emit(FacebookUploadProfileImageSuccessState());
          print('Profile Image URL: $url');
          updateUserData(
              phone: phone,
              name: name,
              bio: bio,
              profileImage: url,
              coverProfile: true);
        }).catchError((error) {
          emit(FacebookUploadProfileImageErrorState());
          print('Error In Getting Profile Image Url: $error');
        });
      }).catchError((error) {
        emit(FacebookUploadProfileImageErrorState());
        print('Error In Getting Profile Image Url: $error');
      });
    }
  }

  //upload cover image to storage
  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    if (coverImage != null) {
      emit(FacebookUserCoverImageUpdateLoadingState());
      FirebaseStorage.instance
          .ref()
          .child('Users/${Uri
          .file(coverImage!.path)
          .pathSegments
          .last}')
          .putFile(coverImage!)
          .then((value) {
        value.ref.getDownloadURL().then((url) {
          //emit(FacebookUploadCoverImageSuccessState());
          print('Cover Image URL: $url');
          updateUserData(
              phone: phone,
              name: name,
              bio: bio,
              coverImage: url,
              coverProfile: true);
        }).catchError((error) {
          emit(FacebookUploadCoverImageErrorState());
          print('Error In Getting Cover Image Url: $error');
        });
      }).catchError((error) {
        emit(FacebookUploadCoverImageErrorState());
        print('Error In Getting Cover Image Url: $error');
      });
    }
  }

  //update user data
  void updateUserData({
    required String name,
    required String phone,
    required String bio,
    String? profileImage,
    String? coverImage,
    bool coverProfile = false,
    BuildContext? context,
  }) {
    if (user != null) {
      if (!coverProfile) {
        emit(FacebookUserUpdateLoadingState());
      }
      UserModel updatedUser = UserModel(
        name: name,
        phone: phone,
        profileImage: profileImage ?? user!.profileImage,
        coverImage: coverImage ?? user!.coverImage,
        bio: bio,
        isEmailVerified: false,
        userId: user!.userId,
        email: user!.email,
      );
      FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.userId)
          .update(updatedUser.toMap())
          .then((value) {
        getUserData();
      }).catchError((error) {
        print('Error: ${error.toString()}');
        emit(FacebookUserUpdateErrorState());
      }).whenComplete(() {
        if (!coverProfile && context != null) {
          showToast('Profile Updated Successfully', ToastStates.success);
          Navigator.pop(context);
        }
      });
    }
  }

  //pick post image from gallery
  void getPostImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        postImage = File(pickedFile.path);
        emit(FacebookPostImagePickedSuccessState());
      } else {
        print('Error In Picking Post Image');
        emit(FacebookPostImagePickedErrorState());
      }
    } catch (error) {
      print('Exception In Picking Post Image: $error');
    }
  }

  //Remove post image in adding new post
  void removePostImage() {
    postImage = null;
    emit(FacebookRemovePostImageState());
  }

  //Create New Post
  void uploadPostImage({
    required String dateTime,
    required String postDescription,
    BuildContext? context,
  }) {
    emit(FacebookCreatePostLoadingState());
    FirebaseStorage.instance
        .ref()
        .child('Posts/${Uri
        .file(postImage!.path)
        .pathSegments
        .last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((url) {
        print('Post Image URL: $url');
        createNewPost(
          isUploadImage: true,
          dateTime: dateTime,
          postDescription: postDescription,
          postImage: url,
        );
      }).catchError((error) {
        emit(FacebookCreatePostErrorState());
        print('Error In Getting Post Image Url: $error');
      });
    }).catchError((error) {
      emit(FacebookCreatePostErrorState());
      print('Error In Getting Post Image Url: $error');
    }).whenComplete(() {
      if (context != null) {
        showToast('Post Created Successfully', ToastStates.success);
        navigateAndFinish(context, const HomeLayout());
      }
    });
  }

  //update user data
  void createNewPost({
    required String dateTime,
    required String postDescription,
    String? postImage,
    BuildContext? context,
    bool isUploadImage = false,
  }) {
    if (user != null) {
      if (!isUploadImage) {
        emit(FacebookCreatePostLoadingState());
      }
      PostModel post = PostModel(
        userId: user!.userId,
        name: user!.name,
        dateTime: dateTime,
        profileImage: user!.profileImage,
        postDescription: postDescription,
        postImage: postImage ?? '',
      );
      FirebaseFirestore.instance
          .collection('Posts')
          .add(post.toMap())
          .then((value) {
        emit(FacebookCreatePostSuccessState());
      }).catchError((error) {
        print('Error: ${error.toString()}');
        emit(FacebookCreatePostErrorState());
      }).whenComplete(() {
        if (context != null) {
          showToast('Post Created Successfully', ToastStates.success);
          navigateAndFinish(context, const HomeLayout());
        }
      });
    }
  }

  //get posts
  void getPosts() {
    emit(FacebookGetPostsLoadingState());
    FirebaseFirestore.instance.collection('Posts')
        .get().then((value) {
      for (var document in value.docs) {
        //Get of of likes
        document.reference.collection('Likes').get().then((value) {
          print('Posts Ids: ${document.id}');
          postsIds.add(document.id);
          posts.add(PostModel.fromJson(document.data()));
          noOfLikes.add(value.docs.length);
          print('Getting Number Of Post Likes Successfully');
          emit(FacebookGetPostsSuccessState());
        }).catchError((error) {
          print('Error In Getting Number Of Post Likes: ${error.toString()}');
        });
      }
    }).catchError((error) {
      print('Error In Getting Posts: $error');
      emit(FacebookGetPostsErrorState(error.toString()));
    }).whenComplete((){
      if(posts.isEmpty){
        emit(FacebookEmptyPostsState());
      }
    });
  }

  //like post
  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Likes')
        .doc(user!.userId)
        .set({'like': true}).then((value) {
      print('Posts Liked Successfully');
      emit(FacebookPostsLikesSuccessState());
    }).catchError((error) {
      print('Error In Like Post: ${error.toString()}');
      emit(FacebookPostsLikesErrorState(error.toString()));
    });
  }

  //get all users
  void getAllUsers() {
    //get all users only first time i go to chat screen
    if (users.isEmpty) {
      emit(FacebookGetAllUserLoadingState());
      FirebaseFirestore.instance.collection('Users').get().then((value) {
        for (var document in value.docs) {
          print('Getting All Users Successfully');

          //get all users except me
          if (document.data()['userId'] != user!.userId) {
            users.add(UserModel.fromJson(document.data()));
          }
        }
        emit(FacebookGetAllUserSuccessState());
      }).catchError((error) {
        print('Error In Getting All Users: $error');
        emit(FacebookGetAllUserErrorState(error.toString()));
      });
    }
  }

  //send messages
  void sendMessages({
    required String receiverId,
    required String dateTime,
    required String messageText,
  }) {
    MessageModel message = MessageModel(
      senderId: user!.userId,
      receiverId: receiverId,
      dateTime: dateTime,
      messageText: messageText,
    );

    //Save message in sender doc
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.userId)
        .collection('Chats')
        .doc(receiverId)
        .collection('Messages')
        .add(message.toMap())
        .then((value) {
      emit(FacebookSendMessagesSuccessState());
    }).catchError((error) {
      print('Error In Sending Message: ${error.toString()}');
      emit(FacebookSendMessagesErrorState(error.toString()));
    });

    //Save message in receiver doc
    FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverId)
        .collection('Chats')
        .doc(user!.userId)
        .collection('Messages')
        .add(message.toMap())
        .then((value) {
      emit(FacebookSendMessagesSuccessState());
    }).catchError((error) {
      print('Error In Sending Message: ${error.toString()}');
      emit(FacebookSendMessagesErrorState(error.toString()));
    });
  }

  //get messages
  void getMessages({required String receiverId }) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.userId)
        .collection('Chats')
        .doc(receiverId)
        .collection('Messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages.clear(); //to prevent duplicate messages
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(FacebookGetMessagesSuccessState());
    });
  }


}



