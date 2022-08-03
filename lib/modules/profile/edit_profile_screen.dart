
import 'package:facebook/cubits/home/facebook_cubit.dart';
import 'package:facebook/cubits/home/facebook_state.dart';
import 'package:facebook/shared/components/components.dart';
import 'package:facebook/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {
   EditProfileScreen({Key? key}) : super(key: key);
  final nameController=TextEditingController();
  final phoneController=TextEditingController();
  final bioController=TextEditingController();
   final formKey = GlobalKey<FormState>();


   @override
  Widget build(BuildContext context) {
    return BlocConsumer<FacebookCubit, FacebookStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var user = FacebookCubit.get(context).user;
        var profileImage = FacebookCubit.get(context).profileImage;
        var coverImage = FacebookCubit.get(context).coverImage;
        if(user!=null){
          nameController.text=user.name!;
          phoneController.text=user.phone!;
          bioController.text=user.bio!;
        }
        return Scaffold(
          appBar:
              defaultAppBar(context: context, title: 'Edit Profile',),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if(state is FacebookUserUpdateLoadingState)
                    const LinearProgressIndicator(),
                    if(state is FacebookUserUpdateLoadingState)
                      const SizedBox(height: 10.0,),
                     Container(
                      height: 260.0,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  height: 210.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: coverImage==null?NetworkImage(
                                        user!.coverImage!,
                                      ): FileImage(coverImage) as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(
                                        4.0,
                                      ),
                                      topRight: Radius.circular(
                                        4.0,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    FacebookCubit.get(context).getCoverImage();
                                  },
                                  icon: const CircleAvatar(
                                    radius: 20.0,
                                    child: Icon(
                                      IconBroken.Camera,
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                                radius: 64.0,
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage: profileImage==null?NetworkImage(
                                    user!.profileImage!,
                                  ) : FileImage(profileImage) as ImageProvider,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  FacebookCubit.get(context).getProfileImage();
                                },
                                icon: const CircleAvatar(
                                  radius: 20.0,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    if(profileImage!=null||coverImage!=null)
                    Row(children: [
                    if(profileImage!=null)
                      Expanded(
                        child: Column(
                          children: [
                            defaultButton(
                              pressed: (){
                                FacebookCubit.get(context).uploadProfileImage(name: nameController.text, phone: phoneController.text, bio: bioController.text);
                              },
                              text: 'Save Profile',
                              isUpperCase: false,
                              radius: 10.0,
                            ),
                            if(state is FacebookUserProfileImageUpdateLoadingState)
                              const SizedBox(height: 5.0,),
                            if(state is FacebookUserProfileImageUpdateLoadingState)
                              const LinearProgressIndicator(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5.0,),
                      if(coverImage!=null)
                        Expanded(
                        child: Column(
                          children: [
                            defaultButton(
                              pressed: (){
                                FacebookCubit.get(context).uploadCoverImage(name: nameController.text, phone: phoneController.text, bio: bioController.text);
                              },
                              text: 'Save Cover',
                              isUpperCase: false,
                              radius: 10.0,
                            ),
                            if(state is FacebookUserCoverImageUpdateLoadingState)
                            const SizedBox(height: 5.0,),
                            if(state is FacebookUserCoverImageUpdateLoadingState)
                              const LinearProgressIndicator(),
                          ],
                        ),
                      ),
                    ],),
                    if(profileImage!=null||coverImage!=null)
                      const SizedBox(
                      height: 30.0,
                    ),
                    defaultTextFormField(
                        validate: (value){
                          if(value!.isEmpty){
                            return 'Name Must Not Be Empty';
                          }
                        },
                        controller: nameController,
                        type: TextInputType.name,
                        label: 'Name',
                        prefix: const Icon(IconBroken.User,),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    defaultTextFormField(
                      validate: (value){
                        if(value!.isEmpty){
                          return 'Bio Must Not Be Empty';
                        }
                      },
                      controller: bioController,
                      type: TextInputType.text,
                      label: 'Bio',
                      prefix: const Icon(IconBroken.Info_Circle,),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    defaultTextFormField(
                      validate: (value){
                        if(value!.isEmpty){
                          return 'Phone Number Must Not Be Empty';
                        }
                      },
                      controller: phoneController,
                      type: TextInputType.phone,
                      label: 'Phone',
                      prefix: const Icon(IconBroken.Call,),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        child: defaultButton(
                          pressed: (){
                            if (formKey.currentState!.validate()) {
                              FacebookCubit.get(context).updateUserData(name: nameController.text, phone: phoneController.text, bio: bioController.text,coverProfile: false,context: context);
                            }
                          },
                          text: 'Save Your Updates',
                          isUpperCase: false,
                          radius: 10.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
