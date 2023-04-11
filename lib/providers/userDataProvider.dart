import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_blog/models/user_model.dart';

final userDataProvider = StreamProvider.family<UserModel, String?>((ref, uid) {
  return FirebaseFirestore.instance
      .collection('userInfo')
      .doc(uid)
      .snapshots()
      .map((snapshot) => UserModel.fromMap(snapshot.data()!));
});