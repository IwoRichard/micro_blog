class PostModel {
  final String userUid;
  final String username;
  final String profilePicUrl;
  final description;
  final  postImageUrl;
  final String postId;
  final  datePosted;
  final List likes;
  final bool isAndroid;

  PostModel({
    required this.userUid,
    required this.username,
    required this.profilePicUrl,
    this.description,
    this.postImageUrl,
    required this.postId,
    required this.datePosted,
    required this.likes,
    required this.isAndroid
  });

  Map<String, dynamic> toJson() {
    return {
      'userUid': userUid,
      'username': username,
      'profilePicUrl': profilePicUrl,
      'description': description,
      'postImageUrl': postImageUrl,
      'postId': postId,
      'datePosted': datePosted,
      'likes': likes,
      'IsAndroid': isAndroid,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      userUid: map['userUid'] ?? '',
      username: map['username'] ?? '',
      profilePicUrl: map['profilePicUrl'] ?? '',
      description: map['description'] ?? '',
      postImageUrl: map['postImageUrl'] ?? '',
      postId: map['postId'] ?? '',
      datePosted: map['datePosted'] ?? '', 
      likes: map['likes'] ?? '',
      isAndroid: map['IsAndroid'] ?? ''
    );
  }
}