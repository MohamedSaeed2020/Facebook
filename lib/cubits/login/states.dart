
abstract class FaceLoginStates{}
class FaceLoginInitialState extends FaceLoginStates{}
class FaceLoginLoadingState extends FaceLoginStates{}
class FaceLoginSuccessState extends FaceLoginStates{}
class FaceLoginErrorState extends FaceLoginStates{
  final  error;

  FaceLoginErrorState(this.error);
}
class FaceChangePasswordVisibilityState extends FaceLoginStates{}