class UserModel {
  String? name;
  String? email;
  String? phone;
  String? userId;
  bool? isEmailVerified;
  String? profileImage;
  String? coverImage;
  String? bio;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.userId,
    required this.isEmailVerified,
    required this.profileImage,
    required this.coverImage,
    required this.bio,
  });

  UserModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      name = json['name'];
      email = json['email'];
      phone = json['phone'];
      userId = json['userId'];
      isEmailVerified = json['isEmailVerified'];
      profileImage = json['profileImage'];
      coverImage = json['coverImage'];
      bio = json['bio'];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'userId': userId,
      'isEmailVerified': isEmailVerified,
      'profileImage': profileImage,
      'coverImage': coverImage,
      'bio': bio,
    };
  }
}
