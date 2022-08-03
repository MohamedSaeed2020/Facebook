import 'package:facebook/cubits/home/facebook_cubit.dart';
import 'package:facebook/cubits/home/facebook_state.dart';
import 'package:facebook/cubits/login/cubit.dart';
import 'package:facebook/modules/profile/edit_profile_screen.dart';
import 'package:facebook/shared/components/components.dart';
import 'package:facebook/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FacebookCubit, FacebookStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var user = FacebookCubit.get(context).user;
          return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ///Cover and Profile Image
              Container(
                height: 260.0,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Container(
                        height: 210.0,
                        width: double.infinity,
                        decoration:  BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                               user!.coverImage!,
                            ),
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
                    ),

                    CircleAvatar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      radius: 64.0,
                      child:  CircleAvatar(
                        radius: 60.0,
                        backgroundImage: NetworkImage(
                            user.profileImage!,
                        ),
                        onBackgroundImageError: (exception,context){
                          print('Error Msg: ${exception.toString()}');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              ///User Name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.name!,
                    style: Theme.of(context).textTheme.bodyText1,
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
              ///User Bio
              Text(
                user.bio!,
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(height: 20.0,),
              ///Update Profile
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        navigateTo(context,  EditProfileScreen());
                      },
                      child: const Text(
                        'Edit Profile',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0,),
                  OutlinedButton(
                    onPressed: () {
                      FaceLoginCubit.get(context).userLogOut(context);
                    },
                    child: Row(
                      children: const [
                        Text(
                          'Log Out',
                        ),
                        SizedBox(width:5.0),
                        Icon(
                          IconBroken.Logout,
                          size: 16.0,
                        ),
                      ],
                    )
                  ),

                ],
              ),
            ],
          ),
        );

      },
    );
  }
}
