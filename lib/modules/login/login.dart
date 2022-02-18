import 'package:facebook/cubits/login/cubit.dart';
import 'package:facebook/cubits/login/states.dart';
import 'package:facebook/layouts/home_layout.dart';
import 'package:facebook/modules/register/register.dart';
import 'package:facebook/network/local/cache_helper.dart';
import 'package:facebook/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FaceLoginCubit(),
      child: BlocConsumer<FaceLoginCubit, FaceLoginStates>(
        listener: (context, state) {
          if (state is FaceLoginErrorState) {
            showToast(state.error, ToastStates.error);
          }
          if (state is FaceLoginSuccessState) {
            CacheHelper.saveData(key: 'userId', value: state.userId)
                .then((value) {
              navigateAndFinish(context, const HomeLayout());
            });
          }
        },
        builder: (context, state) {
          var cubit = FaceLoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Login'),
            ),
            body: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage('assets/images/account.png'),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),

                        ///Email TFF
                        defaultTextFormField(
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email address';
                            }
                          },
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          label: 'Email Address',
                          prefix: const Icon(Icons.email_outlined),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),

                        ///Password TFF
                        defaultTextFormField(
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Password Must Not Be Empty';
                            }
                          },
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          label: 'Password',
                          prefix: const Icon(Icons.lock_outline),
                          suffix: cubit.suffix,
                          suffixPressed: () {
                            cubit.changePasswordVisibility();
                          },
                          isPassword: cubit.isPassword,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),

                        ///Login
                        Conditional.single(
                          context: context,
                          conditionBuilder: (context) =>
                              state is! FaceLoginLoadingState,
                          widgetBuilder: (context) => defaultButton(
                            pressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            text: 'login',
                            radius: 20,
                          ),
                          fallbackBuilder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),

                        ///Register
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                            ),
                            defaultTextButton(
                              onPressed: () {
                                navigateTo(context, RegisterScreen());
                              },
                              text: 'register',
                              isUpperCase:true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
