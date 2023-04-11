import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_blog/models/post_model.dart';

//Timeline posts
final postsProvider = StreamProvider.family<List<PostModel>, String?>((ref, uid) {
  final currentUser = FirebaseAuth.instance.currentUser;
  final userInfoRef = FirebaseFirestore.instance.collection('userInfo').doc(currentUser!.uid);
  return userInfoRef.snapshots().asyncMap((userInfoSnapshot) async {
    final followingIds = List<String>.from(userInfoSnapshot['following']);

    final query = FirebaseFirestore.instance
        .collection('posts')
        .where('userUid', whereIn: [currentUser.uid, ...followingIds])
        .orderBy('datePosted', descending: true);

    final querySnapshot = await query.get();
    final postList = querySnapshot.docs.map((doc) => PostModel.fromMap(doc.data())).toList();
    return postList;
  });
});


//explore page posts pictures
final allPostsProvider = StreamProvider<List<PostModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('posts')
      .where('postImageUrl' ,isNotEqualTo: '')
      .snapshots()
      .map((querySnapshot) =>
          querySnapshot.docs.map((doc) => PostModel.fromMap(doc.data())).toList()
            ..shuffle() 
      );
});


final userPostsProvider = StreamProvider.family<List<PostModel>, String?>((ref, uid) {
  return FirebaseFirestore.instance
      .collection('posts')
      .where('userUid', isEqualTo: uid)
      .where('description', isNotEqualTo: '')
      .snapshots()
      .map((querySnapshot) =>
          querySnapshot.docs.map((doc) => PostModel.fromMap(doc.data())).toList() 
      );
});


final userImagesProvider = StreamProvider.family<List<PostModel>, String?>((ref, uid) {
  return FirebaseFirestore.instance
      .collection('posts')
      .where('userUid', isEqualTo: uid)
      .where('postImageUrl', isNotEqualTo: '')
      .snapshots()
      .map((querySnapshot) =>
          querySnapshot.docs.map((doc) => PostModel.fromMap(doc.data())).toList() 
      );
});