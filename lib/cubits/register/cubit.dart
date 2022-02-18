import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook/cubits/register/states.dart';
import 'package:facebook/models/user_model.dart';
import 'package:facebook/network/local/cache_helper.dart';
import 'package:facebook/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FaceRegisterCubit extends Cubit<FaceRegisterStates> {
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  FaceRegisterCubit() : super(FaceRegisterInitialState());

  static FaceRegisterCubit get(context) {
    return BlocProvider.of(context);
  }

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(FaceRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      if (value.user != null) {
        createUser(
          name: name,
          email: email,
          phone: phone,
          userID: value.user!.uid,
        );
      }
    }).catchError((error) {
      emit(FaceRegisterErrorState(error.toString()));
    });
  }

  void createUser({
    required String email,
    required String phone,
    required String name,
    required String userID,
  }) {
    UserModel user = UserModel(
      name: name,
      email: email,
      phone: phone,
      userId: userID,
      isEmailVerified: false,
      profileImage:
          'https://image.freepik.com/free-photo/photo-thoughtful-handsome-adult-european-man-holds-chin-looks-pensively-away-tries-solve-problem_273609-45891.jpg',
      coverImage:
          'https://image.freepik.com/free-photo/young-man-woman-shirts-posing_273609-41278.jpg',
      bio: 'Write Your Bio Here',
    );
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .set(user.toMap())
        .then((value) {
      CacheHelper.saveData(key: 'userId', value: userID).then((isSaved) {
        if (isSaved == true) {
          //save the registered user id in the public constant user id
          userId = userID;
          print('Login Successfully: $userId');
          emit(FaceRegisterCreateUserSuccessState());
        }
      });
    }).catchError((error) {
      emit(FaceRegisterCreateUserErrorState(error.toString()));
    });
  }

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(FaceRegisterChangePasswordVisibilityState());
  }
}
