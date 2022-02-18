import 'package:facebook/cubits/login/states.dart';
import 'package:facebook/modules/login/login.dart';
import 'package:facebook/network/local/cache_helper.dart';
import 'package:facebook/shared/components/components.dart';
import 'package:facebook/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FaceLoginCubit extends Cubit<FaceLoginStates> {
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  FaceLoginCubit() : super(FaceLoginInitialState());

  static FaceLoginCubit get(context) {
    return BlocProvider.of(context);
  }

  void userLogin({required String email, required String password}) {
    emit(FaceLoginLoadingState());

    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      if (value.user != null) {
        CacheHelper.saveData(key: 'userId', value: value.user!.uid)
            .then((isSaved) {
          if (isSaved == true) {
            userId = value.user!.uid;
            print('Login Successfully: ${value.user!.uid}');
            emit(FaceLoginSuccessState(value.user!.uid));
          }
        });
      }
    }).catchError((error) {
      emit(FaceLoginErrorState(error.toString()));
    });
  }

  void userLogOut(BuildContext context) {
    emit(FaceLogOutLoadingState());

    FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData(key: 'userId').then((value) {
        emit(FaceLogOutSuccessState());
      });
    }).catchError((error) {
      emit(FaceLogOutErrorState(error.toString()));
    }).whenComplete(() {
      navigateAndFinish(context, LoginScreen());
    });
  }

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(FaceChangePasswordVisibilityState());
  }
}
