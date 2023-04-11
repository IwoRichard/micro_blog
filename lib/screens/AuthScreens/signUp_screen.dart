// ignore_for_file: use_build_context_synchronously
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:micro_blog/services/auth_service.dart';
import 'package:micro_blog/utils/pickImage.dart';
import 'package:micro_blog/utils/snackbar.dart';
import 'package:micro_blog/widgets/navBar.dart';
import 'package:micro_blog/widgets/textfields.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool isLoading = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Uint8List? image;

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    bioController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void pickedimage()async{
    final imagee = await pickImage(ImageSource.gallery);
    setState(() {
      image = imagee;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 550
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create an account',
                    style: TextStyle(
                      fontSize: 27, fontWeight: FontWeight.w800
                    ),
                  ),
                  const Opacity(
                    opacity: .7,
                    child: Text(
                      'Start by creating your account',
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        image != null ? CircleAvatar(
                          radius: 35,
                          backgroundImage: MemoryImage(image!),
                          backgroundColor: Colors.grey[300]
                        ) : CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.grey[300]
                        ),
                        TextButton(
                          onPressed: pickedimage, 
                          child: const Text('Change image')
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30,),
                  LoginSignUpTextField(
                    textController: usernameController, 
                    inputAction: TextInputAction.next, 
                    label: 'Username'
                  ),
                  const SizedBox(height: 15,),
                  LoginSignUpTextField(
                    textController: bioController, 
                    inputAction: TextInputAction.next, 
                    label: 'Bio', 
                    maxLines: null,
                    maxLength: 80,
                    showMaxLength: true,
                  ),
                  const SizedBox(height: 15,),
                  LoginSignUpTextField(
                    textController: emailController, 
                    inputAction: TextInputAction.next, 
                    label: 'Email'
                  ),
                  const SizedBox(height: 15,),
                  LoginSignUpTextField(
                    textController: passwordController, 
                    inputAction: TextInputAction.done,
                    showObscureIcon: true, 
                    label: 'Password'
                  ),
                  const SizedBox(height: 15),
                  MaterialButton(
                    height: 50,
                    minWidth: double.infinity,
                    elevation: 0,
                    color: Colors.black87,
                    disabledColor: Colors.black12,
                    disabledTextColor: Colors.black.withOpacity(.5),
                    onPressed: isLoading ? null : ()async{
                      setState(() {isLoading = true;});
                      if (image == null) {
                        snackBar('Add Profile Picture', context, Colors.red);
                      }else{
                        User? res = 
                        await AuthService().signUpUser(
                          email: emailController.text,
                          password: passwordController.text,
                          username: usernameController.text,
                          file: image!,
                          context: context, 
                          bio: bioController.text
                        );
                        if (res != null) {
                          debugPrint('success');
                          Navigator.pushAndRemoveUntil(
                            context, 
                            MaterialPageRoute(builder: (context)=> NavBar(user: res)), 
                            (route) => false
                          );
                        }
                      }
                      setState(() {isLoading = false;});
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16,color:Colors.white)
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Already have an account?",
                              style: TextStyle(color: Colors.black.withOpacity(.5))
                            ),
                            const TextSpan(
                              text: " Log in",
                              style: TextStyle(fontWeight: FontWeight.w500, color:Colors.blue)
                            ),
                          ]
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}