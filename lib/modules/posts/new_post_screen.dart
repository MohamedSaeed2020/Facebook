import 'package:facebook/cubits/home/facebook_cubit.dart';
import 'package:facebook/cubits/home/facebook_state.dart';
import 'package:facebook/shared/components/components.dart';
import 'package:facebook/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewPostScreen extends StatelessWidget {
   NewPostScreen({Key? key}) : super(key: key);
  final postDescriptionController=TextEditingController();
   final dateTime=DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FacebookCubit, FacebookStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = FacebookCubit.get(context);
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Create Post',
            actions: [
              defaultTextButton(
                onPressed: () {
                  if(postDescriptionController.text.isEmpty&&cubit.postImage == null){
                    showToast('Please Enter Something', ToastStates.error);
                  }
                  else{
                    if (cubit.postImage == null) {
                      cubit.createNewPost(
                        isUploadImage:false,
                        context: context,
                        dateTime: dateTime.toString(),
                        postDescription: postDescriptionController.text,
                      );
                    } else {
                      cubit.uploadPostImage(
                        context: context,
                        dateTime: dateTime.toString(),
                        postDescription:  postDescriptionController.text,
                      );
                    }
                  }
                },
                text: 'Post',
                isUpperCase: true,

              ),
              const SizedBox(width: 10.0,),
            ],

          ),
          body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    if(state is FacebookCreatePostLoadingState)
                    const LinearProgressIndicator(),
                    if(state is FacebookCreatePostLoadingState)
                      const SizedBox(height: 10.0,),
                    ///User Info
                    Row(
                      children: [
                         CircleAvatar(
                          radius: 25.0,
                          backgroundImage: NetworkImage(cubit.user!.profileImage!),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children:  [
                                  Text(
                                    cubit.user!.name!,
                                    style: const TextStyle(
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.blue,
                                    size: 16.0,
                                  ),
                                ],
                              ),
                              Text(
                                cubit.user!.bio!,
                                style:
                                    Theme.of(context).textTheme.caption!.copyWith(
                                          height: 1.4,
                                        ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    ///Post Description
                    TextFormField(
                      controller: postDescriptionController,
                      decoration: const InputDecoration(
                        hintText: "What's on your mind?",
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),

                    ///Picked Image
                    if(cubit.postImage!=null)
                      Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          height: 350.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:  FileImage(cubit.postImage!),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(color: Colors.black,width: 1.0),
                            borderRadius:  BorderRadius.circular(4.0),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            cubit.removePostImage();
                          },
                          icon:  CircleAvatar(
                            backgroundColor: Colors.red[500],
                            radius: 20.0,
                            child: const Icon(
                              Icons.close,
                              size: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if(cubit.postImage!=null)
                      const SizedBox(
                      height: 20.0,
                    ),

                    ///Upload Image And Tags
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              cubit.getPostImage();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  IconBroken.Image,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  'Add photo',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0,),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {

                            },
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.tag,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  'Add tags',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        );
      },
    );
  }
}
