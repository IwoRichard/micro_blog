import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:micro_blog/models/post_model.dart';
import 'package:micro_blog/models/user_model.dart';
import 'package:micro_blog/providers/postProvider.dart';
import 'package:micro_blog/screens/PrimaryScreens/profile_screen.dart';
import 'package:micro_blog/screens/SecondaryScreens/view_post_screen.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {

  TextEditingController searchController = TextEditingController();
  bool showUser = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(allPostsProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: showUser ? IconButton(
          onPressed: (){
            setState(() {
              showUser = false;
            });
          }, 
          icon: const Icon(Icons.arrow_back), 
          color: Colors.black,
        ) : null,
        elevation: .5,
        centerTitle: true,
        title: Container(
          height: 45,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue.shade100.withOpacity(.1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            controller: searchController,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.blue.shade700,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                onPressed: (){
                  setState(() {
                    showUser = true;
                  });
                }, 
                icon: const Icon(Iconsax.search_normal_1,size: 17,),
              ),
              hintText: 'Search users',
              hintStyle: const TextStyle(fontSize: 15,color: Colors.grey),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.only(left: 5),
              filled: true
            ),
            onFieldSubmitted: (value) {
              setState(() {
                showUser = true;
              });
            },
          ),
        ),
      ),
      body: showUser ? StreamBuilder(
        stream: FirebaseFirestore.instance
          .collection('userInfo')
          .where('username', isEqualTo: searchController.text).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index){
                  UserModel userModel = UserModel.fromMap(snapshot.data.docs[index].data()??{});
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context)=> ProfileScreen(uid: userModel.uid,))
                      );
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(userModel.profilePicUrl),
                    ),
                    title: Text(userModel.username),
                  );
                }
              );
            } else{
              return const Center(
                child: Text('No User Found!'),
              );
            }
          }
          return const Center(child: CircularProgressIndicator(),);
        },
      ) :
      Padding(
        padding: const EdgeInsets.all(10),
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(allPostsProvider.future),
          child: posts.when(
            data: (data){
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
      ),
    );
  }
}