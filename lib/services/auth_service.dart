// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:micro_blog/models/user_model.dart';
import 'package:micro_blog/services/firebase_storage_service.dart';
import 'package:micro_blog/utils/snackbar.dart';

class AuthService{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> checkIfUsernameExists(String username) async {
    final result = await firebaseFirestore
        .collection('userInfo')
        .where('username', isEqualTo: username)
        .get();
    return result.docs.isNotEmpty;
  }
  
  Future <User?> signUpUser({
    required String email, 
    required String password, 
    required String username, 
    required String bio,
    required Uint8List file,
    required BuildContext context})async{
    try {
      final usernameExists = await checkIfUsernameExists(username);
      if (usernameExists) {
        return snackBar('user already exist', context, Colors.red);
      }

      UserCredential userCredential =  
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      String picUrl = await StorageService().uploadPic(file, 'profilePic', false);

      UserModel userModel = UserModel(
        email: email, 
        username: username, 
        profilePicUrl: picUrl, 
        bio: bio, 
        link: '',
        uid: userCredential.user!.uid, 
        followers: [], 
        following: [],
      );

      await firebaseFirestore.collection('userInfo').doc(userCredential.user?.uid).set(userModel.toJson());
      return userCredential.user; 

    } on FirebaseAuthException catch(e){
      if (e.code == 'email-already-in-use') {
        snackBar("Email already in use", context, Colors.red);
      }
      if (e.code == 'invalid-email') {
        snackBar("The email is badly formatted", context, Colors.red);
      }
      if (e.code =='weak-password') {
        snackBar("Weak Password", context, Colors.red);
      }
    }
    catch (e) {
      debugPrint(e.toString());
    }
  }

  
  Future <User?> login({
    required String email, 
    required String password,
    required BuildContext context})async{
    try {
    UserCredential userCredential =  
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      return userCredential.user;
    } on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found') {
        snackBar("No account related to email", context, Colors.red);
      }
      if (e.code == 'invalid-email') {
        snackBar("The email is badly formatted", context, Colors.red);
      }
      if (e.code == 'wrong-password') {
        snackBar("Incorrect Password", context, Colors.red);
      }
    }
    catch (e) {
      debugPrint(e.toString());
    }
  }


  Future<User?> signout()async{
    await firebaseAuth.signOut();
  }

}

