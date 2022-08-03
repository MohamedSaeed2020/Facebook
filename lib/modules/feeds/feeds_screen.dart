import 'package:facebook/cubits/home/facebook_cubit.dart';
import 'package:facebook/cubits/home/facebook_state.dart';
import 'package:facebook/models/post_model.dart';
import 'package:facebook/shared/styles/icon_broken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:intl/intl.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FacebookCubit, FacebookStates>(
      listener: (context, state) {
        print('listener');
        if (state is FacebookGetUserSuccessState) {
          //FacebookCubit.get(context).getPosts();
        }
      },
      builder: (context, state) {
        print('builder');
        var cubit = FacebookCubit.get(context);
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Card(
                elevation: 5.0,
                margin: const EdgeInsets.all(8.0),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    const Image(
                      width: double.infinity,
                      image: NetworkImage(
                          'https://image.freepik.com/free-photo/young-man-woman-shirts-posing_273609-41278.jpg'),
                      fit: BoxFit.cover,
                      height: 250.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Communicate With Friends',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Conditional.single(
                  context: context,
                  conditionBuilder: (context) => cubit.posts.isNotEmpty,
                  widgetBuilder: (BuildContext context) {
                    return Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) =>
                              buildPostItem(cubit.posts[index], context, index),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 8.0,
                          ),
                          itemCount: cubit.posts.length,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                      ],
                    );
                  },
                  fallbackBuilder: (context) {
                    return Column(
                      children: [
                        if (state is FacebookGetPostsLoadingState)
                          const Center(child: CircularProgressIndicator()),
                        const Center(
                          child: Text(
                            "There's No Posts Yet !",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ],
          ),
        );
      },
    );
  }
}

Widget buildPostItem(PostModel post, BuildContext context, int index) => Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Post User Info
            Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(post.profileImage!),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.name!,
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
                        DateFormat.yMMMEd()
                            .add_jm()
                            .format(DateTime.parse(post.dateTime!)),
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_horiz,
                    size: 16.0,
                  ),
                ),
              ],
            ),

            ///Divider
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
              ),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),

            ///Post Description
            Text(
              post.postDescription!,
              style: Theme.of(context).textTheme.subtitle1,
            ),

            ///Post Image
            if (post.postImage != '')
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 15.0),
                child: Container(
                  height: 300.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(post.postImage!),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(
                      4.0,
                    ),
                  ),
                ),
              ),

            ///Number Of Comments And Likes
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              IconBroken.Heart,
                              size: 16.0,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '${FacebookCubit.get(context).noOfLikes[index]}',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              IconBroken.Chat,
                              size: 16.0,
                              color: Colors.amber,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '0 Comment',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),

            ///Divider
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10.0,
              ),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),

            ///Comment And Like Post
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18.0,
                          backgroundImage: NetworkImage(
                            FacebookCubit.get(context).user!.profileImage!,
                          ),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          'Write a comment..',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                height: 1.4,
                              ),
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                ),
                InkWell(
                  child: Row(
                    children: [
                      const Icon(
                        IconBroken.Heart,
                        size: 16.0,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Like',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                  onTap: () {
                    FacebookCubit.get(context)
                        .likePost(FacebookCubit.get(context).postsIds[index]);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
