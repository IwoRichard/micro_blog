import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_blog/models/post_model.dart';
import 'package:micro_blog/providers/postProvider.dart';
import 'package:micro_blog/widgets/post_card.dart';
import '../SecondaryScreens/view_post_screen.dart';

class PostsTab extends ConsumerWidget {
  final String? uid;
  const PostsTab(this.uid,{super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(userPostsProvider(uid));
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ()=>ref.refresh(userPostsProvider(uid).future),
        child: posts.when(
          data: (data){
            if (data.isEmpty) {
              return const Center(child: Text('No Posts.'),);
            } else {
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: data.length,
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
      )
    );
  }
}