import 'package:facebook/cubits/login/states.dart';
import 'package:facebook/cubits/register/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class FaceRegisterCubit extends Cubit<FaceRegisterStates>{

  IconData suffix=Icons.visibility_outlined;
  bool isPassword=true;
  FaceRegisterCubit() : super(FaceRegisterInitialState());
  static FaceRegisterCubit get (context){
    return BlocProvider.of(context);
  }

void userRegister({required String email,required String password,required String name, String phone=''}){
    emit(FaceRegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value) {
      if(value.user !=null){
        print(value.user!.email);
        print(value.user!.uid);
      }
      emit(FaceRegisterSuccessState());
    }).catchError((error){
      emit(FaceRegisterErrorState(error.toString()));
    });

  }

  void changePasswordVisibility(){
    isPassword=!isPassword;
    suffix=isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(FaceRegisterChangePasswordVisibilityState());
  }


}