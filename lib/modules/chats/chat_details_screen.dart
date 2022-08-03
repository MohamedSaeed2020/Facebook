import 'package:facebook/cubits/home/facebook_cubit.dart';
import 'package:facebook/cubits/home/facebook_state.dart';
import 'package:facebook/models/message_model.dart';
import 'package:facebook/models/user_model.dart';
import 'package:facebook/shared/components/components.dart';
import 'package:facebook/shared/styles/colors.dart';
import 'package:facebook/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

class ChatDetailsScreen extends StatelessWidget {

  //Model of the receiver
  final UserModel? userModel;
  final messageController = TextEditingController();

  ChatDetailsScreen({Key? key, this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          FacebookCubit.get(context).getMessages(
              receiverId: userModel!.userId!,
          );
          return BlocConsumer<FacebookCubit, FacebookStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var cubit = FacebookCubit.get(context);
              return Scaffold(
                appBar: AppBar(
                  titleSpacing: 0.0,
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage(
                            '${userModel!.profileImage}'),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        '${userModel!.name}',
                      ),
                    ],
                  ),
                ),
                body: Conditional.single(
                    context: context,
                    conditionBuilder: (context) => cubit.messages.isNotEmpty,
                    widgetBuilder: (context) =>
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Expanded(

                                child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var message = cubit.messages[index];
                                    if (cubit.user!.userId == message.senderId) {
                                      return buildSenderMessage(message);
                                    }
                                    return buildReceiverMessage(message);
                                  },
                                  separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  itemCount: cubit.messages.length,
                                ),
                              ),

                              ///Enter Your Message
                              Container(
                                padding: const EdgeInsets.only(left: 5.0,),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: messageController,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Type your message here'
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 54.0,
                                      color: defaultColor,
                                      child: MaterialButton(
                                        onPressed: () {
                                          if (messageController.text
                                              .isNotEmpty) {
                                            FacebookCubit.get(context)
                                                .sendMessages(
                                              receiverId: '${userModel!
                                                  .userId}',
                                              dateTime: DateTime.now()
                                                  .toString(),
                                              messageText: messageController
                                                  .text,
                                            );
                                            messageController.clear();
                                          } else {
                                            showToast(
                                                "Can't send empty message",
                                                ToastStates.warning);
                                          }
                                        },
                                        minWidth: 1.0,
                                        child: const Icon(
                                          IconBroken.Send,
                                          size: 16.0,
                                          color: Colors.white,
                                        ),),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    fallbackBuilder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Expanded(
                                child:Center(
                                  child: Text(
                                    "You Don't Have Messages",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 5.0,),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(15.0,),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: messageController,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Type your message here'
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 54.0,
                                    color: defaultColor,
                                    child: MaterialButton(
                                      onPressed: () {
                                        if (messageController.text
                                            .isNotEmpty) {
                                          FacebookCubit.get(context)
                                              .sendMessages(
                                            receiverId: '${userModel!
                                                .userId}',
                                            dateTime: DateTime.now()
                                                .toString(),
                                            messageText: messageController
                                                .text,
                                          );
                                          messageController.clear();
                                        } else {
                                          showToast(
                                              "Can't send empty message",
                                              ToastStates.warning);
                                        }
                                      },
                                      minWidth: 1.0,
                                      child: const Icon(
                                        IconBroken.Send,
                                        size: 16.0,
                                        color: Colors.white,
                                      ),),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                ),
              );
            },
          );
        }
    );
  }

  Widget buildReceiverMessage(MessageModel message) =>
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
            ),
          ),
          child: Text('${message.messageText}',),
        ),
      );

  Widget buildSenderMessage(MessageModel message) =>
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
            color: defaultColor.withOpacity(.2),
            borderRadius: const BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
            ),
          ),
          child: Text('${message.messageText}',),
        ),
      );

}
