import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_blog/screens/AuthScreens/login_screen.dart';
import 'package:micro_blog/services/auth_service.dart';
import 'package:micro_blog/widgets/navBar.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white
      ),
      home: StreamBuilder(
        stream: AuthService().firebaseAuth.authStateChanges(),
        builder: (context,AsyncSnapshot snapshot){
          if (snapshot.hasData) {
            return NavBar(user: snapshot.data,);
          }
          return const LoginScreen();
        }
      ),
    );
  }
}