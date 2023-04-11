import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black,)
        ),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 550,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter your email address',
                  style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w600,color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5,),
                const Text(
                  'A new password will be sent to your email address.',
                ),
                const SizedBox(height: 30,),
                TextField(
                  controller: emailController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.grey,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(fontSize: 15,color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20,),
                MaterialButton(
                  height: 50,
                  minWidth: double.infinity,
                  elevation: 0,
                  color: Colors.black87,
                  disabledColor: Colors.grey.withOpacity(.5),
                  disabledTextColor: Colors.black.withOpacity(.5),
                  onPressed: isLoading ? null : ()async{
                    setState(() {isLoading = true;});
                    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('Enter Valid Email Address'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        )
                      );
                    }else{
                      await resetPassword();
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: const Text(
                    'Reset password',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16,color:Colors.white)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future resetPassword()async{
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Password Reset Email Sent'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        )
      );
      await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim());

    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(e.message.toString()),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        )
      );
    }
  }
}