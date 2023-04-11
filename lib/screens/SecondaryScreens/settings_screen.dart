
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:micro_blog/screens/AuthScreens/forgot_password_screen.dart';
import 'package:micro_blog/screens/AuthScreens/login_screen.dart';
import 'package:micro_blog/services/auth_service.dart';
import 'package:micro_blog/widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .5,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black87,)
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 19, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingsActionTile(
              onTap: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context)=> const ForgotPasswordScreen())
                );
              }, 
              title: 'Reset Password', 
              icon: const Icon(Iconsax.key, color: Colors.black87,), 
              subTitle: 'Forgot your password? Reset.',
            ),
            SettingsActionTile(
              onTap: (){}, 
              title: 'Privacy', 
              icon: const Icon(Iconsax.lock, color: Colors.black87,), 
              subTitle: 'Null button.',
            ),
            SettingsActionTile(
              onTap: (){}, 
              title: 'Security', 
              icon: const Icon(Iconsax.shield, color: Colors.black87,), 
              subTitle: 'Null button.'
            ),
            SettingsActionTile(
              onTap: (){}, 
              title: 'Help & Support', 
              icon: const Icon(Iconsax.message_question, color: Colors.black87,), 
              subTitle: 'Null button'
            ),
            SettingsActionTile(
              onTap: ()async{
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(builder: (context)=> const LoginScreen()), 
                  (route) => false
                );
                await AuthService().signout();
              }, 
              title: 'Log out', 
              icon: Icon(Iconsax.logout, color: Colors.red.shade500,),
              colorr: Colors.red.shade500,
              subTitle: '',
            ),
          ],  
        ),
      ),
    );
  }
}