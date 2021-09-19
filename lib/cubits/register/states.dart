
abstract class FaceRegisterStates {}

class FaceRegisterInitialState extends FaceRegisterStates {}

class FaceRegisterLoadingState extends FaceRegisterStates {}

class FaceRegisterSuccessState extends FaceRegisterStates {}

class FaceRegisterErrorState extends FaceRegisterStates {
  final error;

  FaceRegisterErrorState(this.error);
}

class FaceRegisterChangePasswordVisibilityState extends FaceRegisterStates {}
