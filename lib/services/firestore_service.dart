// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:micro_blog/models/post_model.dart';
import 'package:micro_blog/services/firebase_storage_service.dart';
import 'package:micro_blog/utils/snackbar.dart';
import 'package:uuid/uuid.dart';
import 'dart:io' show Platform;

class FirestoreService{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future uploadPostWithPicture({
    required Uint8List file,
    required String userUid,
    required String username,
    required String profilePicUrl,
    required BuildContext context,
    String? description
    })async{
    try {
      String picUrl = await StorageService().uploadPic(file, 'PostPic', true);
      String postId = const Uuid().v1();

      PostModel postModel = PostModel(
        userUid: userUid, 
        username: username, 
        profilePicUrl: profilePicUrl, 
        postId: postId, 
        description: description ?? "",
        datePosted: DateTime.now(), 
        likes: [], 
        postImageUrl: picUrl,
        isAndroid: Platform.isAndroid ? true : false
      );

      firebaseFirestore.collection('posts').doc(postId).set(postModel.toJson());
      snackBar('Post Successful', context, Colors.green);
    } on FirebaseException catch(e){
      snackBar(e.toString(), context, Colors.red);
    } 
    catch (e) {
      debugPrint(e.toString());
      snackBar(e.toString(), context, Colors.red);
    }
  }

  Future uploadPostNoPicture({
    required String userUid,
    required String username,
    required String profilePicUrl,
    required BuildContext context,
    required String description
    })async{
    try {
      String postId = const Uuid().v1();

      PostModel postModel = PostModel(
        userUid: userUid, 
        username: username, 
        profilePicUrl: profilePicUrl, 
        postId: postId, 
        description: description,
        postImageUrl: '',
        datePosted: DateTime.now(), 
        likes: [],
        isAndroid: Platform.isAndroid ? true : false
      );

      firebaseFirestore.collection('posts').doc(postId).set(postModel.toJson());
      snackBar('Post Successful', context, Colors.green);
    } on FirebaseException catch(e){
      snackBar(e.toString(), context, Colors.red);
    } 
    catch (e) {
      debugPrint(e.toString());
      snackBar(e.toString(), context, Colors.red);
    }
  }


  Future<void> followUser(
    String uid,
    String followId
  )async{
    try {
      DocumentSnapshot snapshot = await firebaseFirestore.collection('userInfo').doc(uid).get();
      List following = (snapshot.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await firebaseFirestore.collection('userInfo').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await firebaseFirestore.collection('userInfo').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await firebaseFirestore.collection('userInfo').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await firebaseFirestore.collection('userInfo').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }

    } catch (e) {
      debugPrint(e.toString());
    }
  }
  
  Future updateProfile({
    required String webSite, 
    required String bio,
    })async{
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;

      await firebaseFirestore.collection('userInfo').doc(uid).update({
        "bio": bio,
        "link": webSite,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future updateProfilePic({
    required String webSite, 
    required String bio,
    required Uint8List file,
    })async{
    try {

      String picUrl = await StorageService().uploadPic(file, 'profilePic', true);


      final User? user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;

      await firebaseFirestore.collection('userInfo').doc(uid).update({
        "bio": bio,
        "link": webSite,
        "profilePicUrl": picUrl
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future likePost(String postId, String uid, List likes)async{
    try {
      if (likes.contains(uid)) {
        await firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future savePost(String postId, List savedPosts,BuildContext context)async{
    try {
      if (savedPosts.contains(postId)) {
        await firebaseFirestore.collection('userInfo').doc(FirebaseAuth.instance.currentUser!.uid).update({
          'savedPosts': FieldValue.arrayRemove([postId]),
        });
      } else {
        await firebaseFirestore.collection('userInfo').doc(FirebaseAuth.instance.currentUser!.uid).update({
          'savedPosts': FieldValue.arrayUnion([postId]),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> postComment({
    required String postId,
    required String comment,
    required String userId,
    required String username,
    required String profilePicUrl,
    required BuildContext context
  })async{
    try {
      if (comment.isNotEmpty) {
        String commentId = const Uuid().v1();
        await firebaseFirestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'userId': userId,
          'postId': postId,
          'username': username,
          'comment': comment,
          'profilePicUrl': profilePicUrl,
          'datePosted': DateTime.now()
        });
        snackBar('Comment Posted', context, Colors.green);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  Future<void> deletePost(postId)async{
    await firebaseFirestore.collection('posts').doc(postId).delete();
  }
}