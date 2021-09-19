import 'package:facebook/cubits/login/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class FaceLoginCubit extends Cubit<FaceLoginStates>{

  IconData suffix=Icons.visibility_outlined;
  bool isPassword=true;
  FaceLoginCubit() : super(FaceLoginInitialState());
  static FaceLoginCubit get (context){
    return BlocProvider.of(context);
  }

  void userLogin({required String email,required String password}){
    emit(FaceLoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword
      (
        email: email,
        password: password,
    ).then((value) {
      if(value.user !=null){
        print(value.user!.email);
        print(value.user!.uid);
      }
      emit(FaceLoginSuccessState());
      }).catchError((error){
      emit(FaceLoginErrorState(error.toString()));
      });



  }

  void changePasswordVisibility(){
    isPassword=!isPassword;
    suffix=isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(FaceChangePasswordVisibilityState());
  }


}