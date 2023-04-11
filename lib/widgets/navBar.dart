import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../screens/PrimaryScreens/explore_screen.dart';
import '../screens/PrimaryScreens/home_screen.dart';
import '../screens/PrimaryScreens/profile_screen.dart';

class NavBar extends StatefulWidget {
  User user;
  NavBar({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;

  List screen = [
    const HomeScreen(),
    const ExploreScreen(),
    ProfileScreen(uid: FirebaseAuth.instance.currentUser?.uid,)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        selectedFontSize: 12,
        selectedItemColor: Colors.black87,
        unselectedItemColor: const Color(0xFF838383),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            activeIcon: Icon(Iconsax.home_15),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.search_normal_1),
            activeIcon: Icon(Iconsax.search_normal_1),
            label: 'Explore'
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.profile_tick),
            activeIcon: Icon(Iconsax.profile_tick5),
            label: 'Profile'
          ),
        ],
      )
    );
  }
}