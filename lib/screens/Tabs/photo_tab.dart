import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:micro_blog/models/post_model.dart';
import 'package:micro_blog/providers/postProvider.dart';
import 'package:micro_blog/screens/SecondaryScreens/view_post_screen.dart';

class PicturesTab extends ConsumerWidget {
   final String? uid;
  const PicturesTab(this.uid, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(userImagesProvider(uid));
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ()=>ref.refresh(userImagesProvider(uid).future),
        child: posts.when(
          data: (data){
            if (data.isEmpty) {
              return const Center(child: Text('No Posts.'),);
            } else{
              return MasonryGridView.count(
                physics: const BouncingScrollPhysics(),
                crossAxisCount: MediaQuery.of(context).size.width < 400 ? 2 : 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                itemCount: data.length, 
                itemBuilder: (context, index){
                  final post = PostModel.fromMap(data[index].toJson());
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context)=>ViewPostScreen(
                            userUid: post.userUid, 
                            username: post.username, 
                            profilePicUrl: post.profilePicUrl, 
                            description: post.description, 
                            postImageUrl: post.postImageUrl, 
                            postId: post.postId, 
                            likes: post.likes,
                            datePosted: post.datePosted, 
                            isAndroid: post.isAndroid
                          )
                        )
                      );
                    },
                    child: Hero(
                      tag: post.postId, 
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          post.postImageUrl, 
                          errorBuilder: (context, error, stackTrace) => Container(),
                        ),
                      )
                    ),
                  );
                }
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
        ) 
      ),
    );
  }
}