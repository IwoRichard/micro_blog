import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:micro_blog/models/post_model.dart';
import 'package:micro_blog/providers/postProvider.dart';
import 'package:micro_blog/providers/userDataProvider.dart';
import 'package:micro_blog/screens/SecondaryScreens/view_post_screen.dart';
import 'package:micro_blog/widgets/post_card.dart';

import '../SecondaryScreens/add_post_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postsProvider(FirebaseAuth.instance.currentUser!.uid));
    final user = ref.watch(userDataProvider(FirebaseAuth.instance.currentUser!.uid));
    return Scaffold(
      appBar: AppBar(
        elevation: .5,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Socialy',
          style: TextStyle(
            color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w600
          ),
        ),
        actions: [
          user.when(
            data: (data){
              return CircleAvatar(
                backgroundImage: NetworkImage(data.profilePicUrl),
                backgroundColor: Colors.blueGrey[100]
              );
            }, 
            error: (error,_){
              debugPrint(error.toString());
              return CircleAvatar(backgroundColor: Colors.orange[200],);
            }, 
            loading: (){
              return CircleAvatar(backgroundColor: Colors.orange[200],);
            }
          ),
          const SizedBox(width: 10,)
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(postsProvider(FirebaseAuth.instance.currentUser!.uid).future),
        child: posts.when(
          data: (data){
            if (data.isEmpty) {
              return const Center(
                child: Text('No Posts. Follow Users. Post'),);
            }else{
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount:  data.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(height: 0,thickness: .7,);
                },
                itemBuilder: (BuildContext context, int index) {
                  final post = PostModel.fromMap(data[index].toJson());
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context){
                            return ViewPostScreen(
                              userUid: post.userUid, 
                              username: post.username, 
                              profilePicUrl: post.profilePicUrl, 
                              description: post.description, 
                              postImageUrl: post.postImageUrl, 
                              postId: post.postId, 
                              likes: post.likes,
                              datePosted: post.datePosted,
                              isAndroid: post.isAndroid,
                            );
                          }
                        )
                      );
                    },
                    child: PostCard(
                      userUid: post.userUid,
                      username: post.username, 
                      profilePicUrl: post.profilePicUrl,
                      postId: post.postId, 
                      likes: post.likes,
                      description: post.description,
                      postImageUrl: post.postImageUrl,
                      datePosted: post.datePosted,
                      isAndroid: post.isAndroid,
                    ),
                  );
                },
              );
            }
          }, 
          error: (error, _){
            debugPrint(error.toString());
            return const Center(child: Text('Trouble!!! Email richardiwo1@gmail.com'),);
          }, 
          loading: (){
            return const Center(child: CircularProgressIndicator.adaptive(),);
          }
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