class CommentModel {
  final String userId;
  final String postId;
  final String username;
  final String comment;
  final String profilePicUrl;
  final datePosted;
  CommentModel({
    required this.userId,
    required this.postId,
    required this.username,
    required this.comment,
    required this.profilePicUrl,
    required this.datePosted,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'postId': postId,
      'username': username,
      'comment': comment,
      'datePosted': datePosted,
      'profilePicUrl': profilePicUrl,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      userId: map['userId'] ?? '',
      postId: map['postId'] ?? '',
      username: map['username'] ?? '',
      comment: map['comment'] ?? '',
      profilePicUrl: map['profilePicUrl'] ?? '',
      datePosted: map['datePosted'] ?? '', 
    );
  }
}
