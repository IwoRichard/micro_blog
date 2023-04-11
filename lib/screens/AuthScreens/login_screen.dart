// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:micro_blog/screens/AuthScreens/forgot_password_screen.dart';
import 'package:micro_blog/screens/AuthScreens/signUp_screen.dart';
import 'package:micro_blog/services/auth_service.dart';
import 'package:micro_blog/widgets/navBar.dart';
import 'package:micro_blog/widgets/textfields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 27, fontWeight: FontWeight.w800
                    ),
                  ),
                  const Opacity(
                    opacity: .7,
                    child: Text(
                      'Welcome back! Please enter your details.',
                    ),
                  ),
                  const SizedBox(height: 30,),
                  LoginSignUpTextField(
                    textController: emailController, 
                    inputAction: TextInputAction.next, 
                    label: 'Email',
                  ),
                  const SizedBox(height: 15,),
                  LoginSignUpTextField(
                    textController: passwordController, 
                    inputAction: TextInputAction.done,
                    showObscureIcon: true, 
                    label: 'Password',
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: (){
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 200),
                            pageBuilder: (context, animation, secondaryAnimation) => const ForgotPasswordScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          )
                        );
                      }, 
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    )
                  ),
                  const SizedBox(height: 15),
                  MaterialButton(
                    height: 50,
                    minWidth: double.infinity,
                    elevation: 0,
                    focusElevation: 0,
                    color: Colors.black87,
                    disabledColor: Colors.black12,
                    disabledTextColor: Colors.black.withOpacity(.5),
                    onPressed: isLoading ? null : ()async{
                      setState(() {isLoading = true;});
                      User? res = await AuthService().login(
                        context: context,
                        email: emailController.text,
                        password: passwordController.text
                      );
                      if (res != null) {
                        debugPrint('success');
                        Navigator.pushAndRemoveUntil(
                          context, 
                          MaterialPageRoute(builder: (context)=> NavBar(user: res)), 
                          (route) => false
                        );
                      }
                      setState(() {isLoading = false;});
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16,color:Colors.white)
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 200),
                            pageBuilder: (context, animation, secondaryAnimation) => const SignUpScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          )
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account?",
                              style: TextStyle(color: Colors.black.withOpacity(.5))
                            ),
                            const TextSpan(
                              text: " Sign up",
                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blue)
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