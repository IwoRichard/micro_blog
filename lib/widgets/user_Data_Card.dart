import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_blog/screens/SecondaryScreens/view_post_picture.dart';

import '../providers/userDataProvider.dart';
import '../screens/SecondaryScreens/edit_profile.dart';
import '../screens/SecondaryScreens/followers_screen.dart';
import '../screens/SecondaryScreens/following_screen.dart';
import '../services/firestore_service.dart';
import '../utils/snackbar.dart';
import 'follow_edit_button.dart';

class UserData extends ConsumerWidget {
  final String? uid;
  const UserData(this.uid, {
    super.key,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider(uid));
    return SliverToBoxAdapter(
      child: SizedBox(
        child: userData.when(
          data: (data){
            return CardColumn(
              name: data.username, 
              bio: data.bio, 
              link: data.link, 
              following: data.following.length.toString(), 
              followers: data.followers.length.toString(),
              profilePicUrl: data.profilePicUrl,
              showProfileImage: true,
              isFollowing: data.followers.contains(FirebaseAuth.instance.currentUser!.uid),
              uid: uid,
            );
          }, 
          error: (error, _){
            debugPrint(error.toString());
            return CardColumn(name: '', bio: '', link: '', following: '', followers: '');
          }, 
          loading: (){
            return CardColumn(name: '', bio: '', link: '', following: '', followers: '');
          }
        )
      ),
    );
  }
}


class CardColumn extends StatefulWidget {
  String name;
  String bio;
  String link;
  String following;
  String followers;
  final uid;
  bool showProfileImage;
  String? profilePicUrl;
  bool isFollowing;
  CardColumn({
    Key? key,
    this.isFollowing = false,
    this.uid,
    required this.name,
    required this.bio,
    required this.link,
    required this.following,
    required this.followers,
    this.showProfileImage = false,
    this.profilePicUrl,
  }) : super(key: key);

  @override
  State<CardColumn> createState() => _CardColumnState();
}

class _CardColumnState extends State<CardColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context)=> ViewPostPicture(image: widget.profilePicUrl??"", tag: widget.uid))
                );
              },
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200],
                backgroundImage: widget.showProfileImage ? NetworkImage(widget.profilePicUrl.toString()) : null,
              ),
            ),
            const Spacer(),
            widget.uid == FirebaseAuth.instance.currentUser!.uid ? FollowEditButton(
              backgroundColor: Colors.white, 
              borderColor: Colors.blue.shade100, 
              title: 'Edit profile', 
              titleColor: Colors.blue.shade700,
              function: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context)=> const EditProfileScreen()
                  )
                );
              },
            ) : widget.isFollowing ? FollowEditButton(
              backgroundColor: Colors.white, 
              borderColor: Colors.grey, 
              title: 'Unfollow', 
              titleColor: Colors.black,
              function: ()async{
                await FirestoreService()
                  .followUser(FirebaseAuth.instance.currentUser!.uid, widget.uid);
                
                setState(() {
                  widget.isFollowing = false;
                });
              },
            ) : FollowEditButton(
              backgroundColor: Colors.black87, 
              borderColor: Colors.black87, 
              title: 'Follow', 
              titleColor: Colors.white,
              function: ()async{
                await FirestoreService()
                  .followUser(FirebaseAuth.instance.currentUser!.uid, widget.uid);

                setState(() {
                  widget.isFollowing = true;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 5,),
        Text(
          widget.name,
          style: const TextStyle(
            fontSize: 16.5, fontWeight: FontWeight.w500
          ),
        ),
        const SizedBox(height: 7,),
        Text(
          widget.bio,
          style: const TextStyle(
            fontSize: 15
          ),
        ),
        const SizedBox(height: 7,),
        Row(
          children: [
            widget.link != '' ? Icon(Icons.link, size: 18,color: Colors.black.withOpacity(.5),) : Container(),
            const SizedBox(width: 5,),
            widget.link != '' ? InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: widget.link)).then((value) => 
                  ScaffoldMessenger.of(context).showSnackBar(
                    snackBar('Url is copied to the clipboard', context, Colors.green)
                  )
                );
              },
              child: Text(
                widget.link,
                style: TextStyle(
                  fontSize: 15, color: Colors.blue.shade500
                ),
              ),
            ) : Container(),
          ],
        ),
        const SizedBox(height: 7,),
        Row(
          children: [
            InkWell(
              onTap: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context)=> FollowingScreen(uid: widget.uid,)
                  )
                );
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.following,
                      style: const TextStyle(
                        color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600
                      )
                    ),
                    TextSpan(
                      text: ' Following',
                      style: TextStyle(
                        color: Colors.black.withOpacity(.5), fontSize: 16, fontWeight: FontWeight.w500
                      )
                    )
                  ]
                )
              ),
            ),
            const SizedBox(width: 10,),
            InkWell(
              onTap: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context)=> FollowersScreen(uid: widget.uid,)
                  )
                );
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.followers,
                      style: const TextStyle(
                        color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600
                      )
                    ),
                    TextSpan(
                      text: ' Followers',
                      style: TextStyle(
                        color: Colors.black.withOpacity(.5), fontSize: 16, fontWeight: FontWeight.w500
                      )
                    )
                  ]
                )
              ),
            ),
          ],
        )
      ],
    );
  }
}