import 'package:facebook/cubits/register/cubit.dart';
import 'package:facebook/cubits/register/states.dart';
import 'package:facebook/layouts/home_layout.dart';
import 'package:facebook/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

class RegisterScreen extends StatelessWidget {
  ///variables
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FaceRegisterCubit(),
      child: BlocConsumer<FaceRegisterCubit, FaceRegisterStates>(
        listener: (context, state) {
          if (state is FaceRegisterCreateUserSuccessState) {
            navigateAndFinish(context, const HomeLayout());
          }
        },
        builder: (context, state) {
          var cubit = FaceRegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Register'),
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

                        ///Name TFF
                        defaultTextFormField(
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                          },
                          controller: nameController,
                          type: TextInputType.name,
                          label: 'User Name',
                          prefix: const Icon(Icons.person),
                        ),
                        const SizedBox(
                          height: 15.0,
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
                              return 'Password is too short';
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
                          height: 15.0,
                        ),

                        ///Phone TFF
                        defaultTextFormField(
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
                            }
                          },
                          controller: phoneController,
                          type: TextInputType.phone,
                          label: 'Phone',
                          prefix: const Icon(Icons.phone),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),

                        ///Register
                        Conditional.single(
                          context: context,
                          conditionBuilder: (context) =>
                              state is! FaceRegisterLoadingState,
                          widgetBuilder: (context) => defaultButton(
                            pressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            text: 'register',
                            radius: 20,
                          ),
                          fallbackBuilder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
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
