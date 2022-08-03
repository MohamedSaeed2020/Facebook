class PostModel {
  String? userId;
  String? name;
  String? profileImage;
  String? dateTime;
  String? postDescription;
  String? postImage;

  PostModel({
    required this.userId,
    required this.name,
    required this.profileImage,
    required this.dateTime,
    required this.postDescription,
    required this.postImage,
  });

  PostModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      userId = json['userId'];
      name = json['name'];
      profileImage = json['profileImage'];
      dateTime = json['dateTime'];
      postDescription = json['postDescription'];
      postImage = json['postImage'];

    }
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'profileImage': profileImage,
      'dateTime': dateTime,
      'postDescription': postDescription,
      'postImage': postImage,
    };
  }
}
