import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:micro_blog/screens/SecondaryScreens/add_post_screen.dart';
import 'package:micro_blog/screens/SecondaryScreens/settings_screen.dart';
import 'package:micro_blog/screens/Tabs/photo_tab.dart';
import 'package:micro_blog/screens/Tabs/post_tab.dart';
import 'package:micro_blog/widgets/user_Data_Card.dart';

class ProfileScreen extends StatefulWidget {
  final String? uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  toolbarHeight: 50,
                  pinned: true,
                  backgroundColor: Colors.white,
                  leading: widget.uid != FirebaseAuth.instance.currentUser?.uid ? 
                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.black87,)
                    ): null,
                  elevation: 0,
                  actions: [
                    if(widget.uid == FirebaseAuth.instance.currentUser?.uid)
                    IconButton(
                      onPressed: (){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context)=> const SettingsScreen())
                        );
                      }, 
                      icon: const Icon(Iconsax.setting_2, color: Colors.black87,)
                    )
                  ],
                ),
                UserData(widget.uid),
                const SliverToBoxAdapter(child: SizedBox(height: 10,)),
                const SliverAppBar(
                  pinned: true,
                  primary: false,
                  leading: null,
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  elevation: 0,
                  title: TabBar(
                    indicatorPadding: EdgeInsets.zero,
                    indicatorColor: Colors.black87,
                    labelColor:Colors.black,
                    unselectedLabelColor: Colors.grey,
                    labelPadding: EdgeInsets.only(left: 0),
                    tabs: [
                      Tab(icon: Icon(Iconsax.edit,size: 23,),),
                      Tab(icon: Icon(Iconsax.picture_frame,size: 23,),),
                    ]
                  ),
                ),
              ];
            }, 
            body: TabBarView(
              children: [
                PostsTab(widget.uid),
                PicturesTab(widget.uid),
              ]
            )
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context)=> const AddPostScreen())
          );
        },
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Iconsax.edit),
      ),
    );
  }
}