import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_blog/models/user_model.dart';

final followersFutureProvider = FutureProvider.autoDispose.family<List<String>, String>((ref, userId) async {
  final docSnapshot = await FirebaseFirestore.instance.collection('userInfo').doc(userId).get();
  final followers = docSnapshot.get('followers') as List<dynamic>;
  return followers.cast<String>();
});

final followingFutureProvider = FutureProvider.autoDispose.family<List<String>, String>((ref, userId) async {
  final docSnapshot = await FirebaseFirestore.instance.collection('userInfo').doc(userId).get();
  final following = docSnapshot.get('following') as List<dynamic>;
  return following.cast<String>();
});


final userModelsFutureProvider = FutureProvider.autoDispose.family<List<UserModel>, List<String>>((ref, followers) async {
  final userModels = <UserModel>[];
  final usersSnapshot = await FirebaseFirestore.instance.collection('userInfo').where(FieldPath.documentId, whereIn: followers).get();
  for (final userSnapshot in usersSnapshot.docs) {
    final userModel = UserModel(
      email: userSnapshot.get('email'), 
      username: userSnapshot.get('username'), 
      profilePicUrl: userSnapshot.get('profilePicUrl'), 
      bio: userSnapshot.get('bio'), 
      link: userSnapshot.get('link'), 
      uid: userSnapshot.get('uid'), 
      followers: userSnapshot.get('followers'), 
      following: userSnapshot.get('following'),
    );
    userModels.add(userModel);
  }
  return userModels;
});