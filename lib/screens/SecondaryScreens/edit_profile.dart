import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:micro_blog/services/firestore_service.dart';
import 'package:micro_blog/utils/pickImage.dart';
import 'package:micro_blog/widgets/textfields.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController websiteController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  Uint8List? image;
  String profilePicUrl = '';

  void pickedimage()async{
    final imagee = await pickImage(ImageSource.gallery);
    setState(() {
      image = imagee;
    });
  }

  @override
  void dispose() {
    super.dispose();
    websiteController.dispose();
    bioController.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  getUserDetail() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('userInfo')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (snapshot.exists) {
      setState(() {
        profilePicUrl = snapshot.data()!['profilePicUrl'];
      });
      websiteController.text = snapshot.data()!['link'] ?? '';
      bioController.text = snapshot.data()!['bio'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .5,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black87,)
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 19, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: ()async{
              image == null ? await FirestoreService().updateProfile(
                webSite: websiteController.text, 
                bio: bioController.text
              ) : await FirestoreService().updateProfilePic(
                webSite: websiteController.text, 
                bio: bioController.text, 
                file: image!
              );
              Navigator.pop(context);
            }, 
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 16, color: Colors.blue.shade700,
              ),
            )
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: image != null ?
                CircleAvatar(
                  radius: 32,
                  backgroundImage: MemoryImage(image!),
                  backgroundColor: Colors.orange[200],
                ) : CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(profilePicUrl),
                  backgroundColor: Colors.orange[200],
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: (){pickedimage();}, 
                  child: Text(
                    'Change profile picture',
                    style: TextStyle(
                      fontSize: 16, color: Colors.blue.shade700,
                    ),
                  )
                ),
              ),
              const SizedBox(height: 15,),
              textFieldTitle('Website'),
              EditProfileTextField(
                hintextt: 'https://example.com', 
                textController: websiteController,
                showMaxLength: false,
              ),
              const SizedBox(height: 15,),
              textFieldTitle('Bio'),
              EditProfileTextField(
                hintextt: 'Hello world', 
                textController: bioController, 
                maxlines: 2,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget textFieldTitle(title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500
      ),
    );
  }
}