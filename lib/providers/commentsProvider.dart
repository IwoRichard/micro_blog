import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_blog/models/comment_model.dart';

final commentsProvider = StreamProvider.family<List<CommentModel>, String?>((ref, postId) {
  return FirebaseFirestore.instance
      .collection('posts')
      .doc(postId)
      .collection('comments')
      .snapshots()
      .map((querySnapshot) => 
          querySnapshot.docs.map((doc) => CommentModel.fromMap(doc.data())).toList()
      );
});