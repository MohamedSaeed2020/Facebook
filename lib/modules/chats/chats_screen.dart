import 'package:facebook/cubits/home/facebook_cubit.dart';
import 'package:facebook/cubits/home/facebook_state.dart';
import 'package:facebook/models/user_model.dart';
import 'package:facebook/modules/chats/chat_details_screen.dart';
import 'package:facebook/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FacebookCubit, FacebookStates>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var cubit=FacebookCubit.get(context);
        return Conditional.single(
          context: context,
          conditionBuilder: (context)=>cubit.users.isNotEmpty,
          widgetBuilder: (context)=>ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context,index)=>buildChatItem(cubit.users[index],context),
            separatorBuilder: (context,index)=>myDivider(),
            itemCount: cubit.users.length,
          ),
          fallbackBuilder: (context) =>const Center(
            child: Text(
              "You Don't Have Friends",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildChatItem(UserModel user,BuildContext context) {
    return InkWell(
      onTap: (){
        navigateTo(context, ChatDetailsScreen(userModel: user,));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
             CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage('${user.profileImage}'),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Row(
              children:  [
                Text(
                  '${user.name}',
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
          ],
        ),
      ),
    );
  }
}
