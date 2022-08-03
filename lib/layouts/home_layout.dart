import 'package:facebook/cubits/home/facebook_cubit.dart';
import 'package:facebook/cubits/home/facebook_state.dart';
import 'package:facebook/modules/posts/new_post_screen.dart';
import 'package:facebook/shared/components/components.dart';
import 'package:facebook/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FacebookCubit, FacebookStates>(
      listener: (context, state) {
        if(state is FacebookAddNewPostState){
          navigateTo(context,  NewPostScreen());
        }

      },
      builder: (context, state) {
        FacebookCubit cubit = FacebookCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            actions: [
              IconButton(onPressed: (){}, icon: const Icon(IconBroken.Notification)),
              IconButton(onPressed: (){},icon: const Icon(IconBroken.Search)),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              cubit.changeBottomNavigation(index);
            },

            currentIndex: cubit.currentIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(IconBroken.Home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(IconBroken.Chat), label: 'Chats'),
              BottomNavigationBarItem(icon: Icon(IconBroken.Paper_Upload), label: 'Post'),
              BottomNavigationBarItem(icon: Icon(IconBroken.Setting), label: 'Settings'),
            ],
          ),
        );
      },
    );
  }
}
