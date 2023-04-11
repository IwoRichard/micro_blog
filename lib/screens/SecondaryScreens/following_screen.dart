import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_blog/providers/followersProvider.dart';
import 'package:micro_blog/screens/PrimaryScreens/profile_screen.dart';
import 'package:micro_blog/services/firestore_service.dart';
import 'package:micro_blog/widgets/follow_edit_button.dart';

class FollowingScreen extends ConsumerStatefulWidget {
  final String uid;
  FollowingScreen({
    required this.uid,
  });

  @override
  ConsumerState<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends ConsumerState<FollowingScreen> {
  @override
  Widget build(BuildContext context) {
    final followsFuture = ref.watch(followingFutureProvider(widget.uid));
    final followingFuture = ref.watch(followingFutureProvider(FirebaseAuth.instance.currentUser!.uid));
    final userModelsFuture = ref.watch(userModelsFutureProvider(followsFuture.value ?? []));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .5,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black87,)
        ),
        title: const Text(
          'Following',
          style: TextStyle(
            fontSize: 19, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ),
      body: userModelsFuture.when(
        data: (data){
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final userModel = data[index];
              final isFollowing = followingFuture.value?.contains(userModel.uid) ?? false;
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context){
                        return ProfileScreen(uid: userModel.uid);
                      }
                    )
                  );
                },
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.orange[200],
                  backgroundImage: NetworkImage(userModel.profilePicUrl),
                ),
                title:  Text(
                  userModel.username,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  userModel.bio,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: userModel.uid == FirebaseAuth.instance.currentUser!.uid ? null : FollowEditButton(
                  backgroundColor: isFollowing ? Colors.white : Colors.black87, 
                  borderColor: isFollowing ? Colors.grey : Colors.black87, 
                  title: isFollowing ? 'Unfollow' : 'Follow', 
                  titleColor: isFollowing ? Colors.black : Colors.white,
                  function: () async {
                    await showDialog(
                      context: context, 
                      builder: (context){
                        return AlertDialog(
                          title: Text(
                            'Unfollow ${userModel.username}'
                          ),
                          actions: [
                            TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                              }, 
                              child: const Text(
                                'No',
                                style: TextStyle(color: Colors.red),
                              )
                            ),
                            TextButton(
                              onPressed: ()async{
                                await FirestoreService().followUser(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  userModel.uid,
                                );
                                Navigator.pop(context);
                                ref.refresh(followingFutureProvider(FirebaseAuth.instance.currentUser!.uid));
                              }, 
                              child: const Text('Yes'),
                            )
                          ],
                        );
                      }
                    );
                  },
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 7,);
            },
          );
        }, 
        error: (error, stackTrace) => const Center(child: Text('Failed to load followers')),
        loading: () => const Center(child: CircularProgressIndicator()),
      )
    );
  }
}