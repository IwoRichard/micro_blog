class UserModel {
  final String email;
  final String username;
  final String profilePicUrl;
  final String bio;
  final String link;
  final String uid;
  final List followers;
  final List following;
  
  UserModel({
    required this.email,
    required this.username,
    required this.profilePicUrl,
    required this.bio,
    required this.link,
    required this.uid,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'profilePicUrl': profilePicUrl,
      'bio': bio,
      'link': link,
      'uid': uid,
      'followers': followers,
      'following': following,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      profilePicUrl: map['profilePicUrl'] ?? '',
      bio: map['bio'] ?? '',
      link: map['link'] ?? '',
      uid: map['uid'] ?? '',
      followers: List.from(map['followers']),
      following: List.from(map['following']),
    );
  }
}