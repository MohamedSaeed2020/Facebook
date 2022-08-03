abstract class FacebookStates {}

/// Mix States
class FacebookInitialState extends FacebookStates {}
class FacebookChangeBottomNavigationState extends FacebookStates {}
class FacebookAddNewPostState extends FacebookStates {}

///Getting User Data States
class FacebookGetUserLoadingState extends FacebookStates {}
class FacebookGetUserSuccessState extends FacebookStates {}
class FacebookGetUserErrorState extends FacebookStates {
  final String error;

  FacebookGetUserErrorState(
    this.error,
  );
}
///Getting All User Data States
class FacebookGetAllUserLoadingState extends FacebookStates {}
class FacebookGetAllUserSuccessState extends FacebookStates {}
class FacebookGetAllUserErrorState extends FacebookStates {
  final String error;

  FacebookGetAllUserErrorState(
      this.error,
      );
}
/// Picking Images States
class FacebookProfileImagePickedSuccessState extends FacebookStates {}
class FacebookProfileImagePickedErrorState extends FacebookStates {}
class FacebookCoverImagePickedSuccessState extends FacebookStates {}
class FacebookCoverImagePickedErrorState extends FacebookStates {}

///Upload Profile And Cover Images States
class FacebookUploadProfileImageSuccessState extends FacebookStates {}
class FacebookUploadProfileImageErrorState extends FacebookStates {}
class FacebookUploadCoverImageSuccessState extends FacebookStates {}
class FacebookUploadCoverImageErrorState extends FacebookStates {}

///Update Profile States
class FacebookUserUpdateLoadingState extends FacebookStates {}
class FacebookUserUpdateErrorState extends FacebookStates {}
class FacebookUserProfileImageUpdateLoadingState extends FacebookStates {}
class FacebookUserCoverImageUpdateLoadingState extends FacebookStates {}

///Create Post States
class FacebookCreatePostLoadingState extends FacebookStates {}
class FacebookCreatePostSuccessState extends FacebookStates {}
class FacebookCreatePostErrorState extends FacebookStates {}
//Picking Post Images
class FacebookPostImagePickedSuccessState extends FacebookStates {}
class FacebookPostImagePickedErrorState extends FacebookStates {}
class FacebookRemovePostImageState extends FacebookStates {}

///Getting Posts States
class FacebookGetPostsLoadingState extends FacebookStates {}
class FacebookGetPostsSuccessState extends FacebookStates {}
class FacebookEmptyPostsState extends FacebookStates {}
class FacebookGetPostsErrorState extends FacebookStates {
  final String error;

  FacebookGetPostsErrorState(
      this.error,
      );
}

///Getting Posts Likes States
class FacebookPostsLikesSuccessState extends FacebookStates {}
class FacebookPostsLikesErrorState extends FacebookStates {
  final String error;

  FacebookPostsLikesErrorState(
      this.error,
      );
}
class FacebookGetPostsLikesSuccessState extends FacebookStates {}
class FacebookGetPostsLikesErrorState extends FacebookStates {
  final String error;

  FacebookGetPostsLikesErrorState(
      this.error,
      );
}


///Chat States
class FacebookSendMessagesSuccessState extends FacebookStates {}
class FacebookSendMessagesErrorState extends FacebookStates {
  final String error;

  FacebookSendMessagesErrorState(
      this.error,
      );
}
class FacebookGetMessagesSuccessState extends FacebookStates {}
