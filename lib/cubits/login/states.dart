abstract class FaceLoginStates {}

///Login States
class FaceLoginInitialState extends FaceLoginStates {}

class FaceLoginLoadingState extends FaceLoginStates {}

class FaceLoginSuccessState extends FaceLoginStates {
  final String userId;

  FaceLoginSuccessState(this.userId);
}

class FaceLoginErrorState extends FaceLoginStates {
  final String error;

  FaceLoginErrorState(this.error);
}

///Logout States
class FaceLogOutLoadingState extends FaceLoginStates {}

class FaceLogOutSuccessState extends FaceLoginStates {}

class FaceLogOutErrorState extends FaceLoginStates {
  final String error;

  FaceLogOutErrorState(this.error);
}

///Mix States
class FaceChangePasswordVisibilityState extends FaceLoginStates {}
