import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:micro_blog/models/comment_model.dart';
import 'package:micro_blog/providers/commentsProvider.dart';
import 'package:micro_blog/providers/postProvider.dart';
import 'package:micro_blog/screens/PrimaryScreens/profile_screen.dart';
import 'package:micro_blog/screens/SecondaryScreens/view_post_picture.dart';
import 'package:micro_blog/services/firestore_service.dart';

import '../../widgets/action_icons.dart';

class ViewPostScreen extends ConsumerStatefulWidget {
  final String userUid;
  final String username;
  final String profilePicUrl;
  final String description;
  final  String postImageUrl;
  final String postId;
  final datePosted;
  final List likes;
  final bool isAndroid;
  const ViewPostScreen({
    Key? key,
    required this.userUid,
    required this.username,
    required this.profilePicUrl,
    required this.description,
    required this.postImageUrl,
    required this.postId,
    required this.likes,
    this.datePosted,
    required this.isAndroid
  }) : super(key: key);

  @override
  ConsumerState<ViewPostScreen> createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends ConsumerState<ViewPostScreen> {

  TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(commentsProvider(widget.postId));
    final comment = comments.value??[];
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
          'Post',
          style: TextStyle(
            fontSize: 19, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        actions: [
          if(widget.userUid == FirebaseAuth.instance.currentUser!.uid)
          TextButton(
            onPressed: ()async{
              await showDialog(
                context: context, 
                builder: (context){
                  return AlertDialog(
                    title: const Text('Delete Post'),
                    actions: [
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        }, 
                        child: const Text('No',)
                      ),
                      TextButton(
                        onPressed: ()async{
                          await FirestoreService().deletePost(widget.postId);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          ref.refresh(postsProvider(widget.userUid));
                        }, 
                        child: const Text('Yes')
                      )
                    ],
                  );
                }
              );
            },  
            child: const Text(
              'Delete Post',
              style: TextStyle(color: Colors.red),
            )
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context){
                          return ProfileScreen(uid: widget.userUid);
                        }
                      )
                    );
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.orange[100],
                      backgroundImage: NetworkImage(widget.profilePicUrl),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16
                        ),
                      ),
                      const SizedBox(height: 2,),
                      Text(
                        DateFormat.yMMMd().format(
                          widget.datePosted.toDate()
                        ),
                        style: const TextStyle(
                          color: Colors.grey, fontSize: 15.5
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if(widget.postImageUrl == "")
              const SizedBox(height: 10,),
              if(widget.postImageUrl == "")
              Text(widget.description),
              if(widget.postImageUrl != "")
              const SizedBox(height: 10,),
              if(widget.postImageUrl != "")
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context)=> ViewPostPicture(
                        image: widget.postImageUrl, 
                        tag: widget.postId,
                      )
                    )
                  );
                },
                child: Hero(
                  tag: widget.postId,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(widget.postImageUrl),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                'Socialy for ${widget.isAndroid == true ? 'Android' : 'IOS'}',
                style: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 15,
                ),
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  actionButton(
                    ontap: ()async{
                      await FirestoreService().likePost(
                        widget.postId, 
                        FirebaseAuth.instance.currentUser!.uid, 
                        widget.likes
                      );
                      ref.refresh(postsProvider(FirebaseAuth.instance.currentUser!.uid));
                    }, 
                    number: '${widget.likes.length.toString()} ${widget.likes.length > 1 ? 'likes' : 'like'}',
                    icon: widget.likes.contains(FirebaseAuth.instance.currentUser!.uid) ? const Icon(
                      Iconsax.heart5,
                      color: Colors.red,
                      size: 20,
                    ) : const Icon(
                      Iconsax.heart,
                      color: Colors.grey,
                      size: 20,
                    )
                  ),
                  const SizedBox(width: 15,),
                  actionButton(
                    ontap: (){}, 
                    number: '${comment.length.toString()} comments',//'0 comments', 
                    icon: const Icon(
                      Iconsax.message,
                      color: Colors.grey,
                      size: 18,
                    )
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              if(widget.postImageUrl != "" && widget.description != "")
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: widget.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16
                      )
                    ),
                    TextSpan(
                      text: ' ${widget.description}',
                      style: const TextStyle(
                        fontSize: 15.5
                      )
                    ),
                  ]
                )
              ),
              const SizedBox(height: 10,),
              const Divider(),
              comments.when(
                data: (data){
                  if (data.isEmpty) {
                    return const Center(child: Text('No Comments'),);
                  } else {
                    return ListView.separated(
                      primary: true,
                      shrinkWrap: true,
                      itemCount: data.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(height: 0,thickness: .7,);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        final comment = CommentModel.fromMap(data[index].toJson());
                        return ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          minVerticalPadding: 0,
                          leading: InkWell(
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context)=>ProfileScreen(uid: comment.userId))
                              );
                            },
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(comment.profilePicUrl),
                              backgroundColor: Colors.grey[200],
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                comment.username,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 5,),
                              Opacity(
                                opacity: .5,
                                child: Text(
                                  DateFormat.yMMMd().format(
                                    widget.datePosted.toDate()
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            comment.comment,
                            style: const TextStyle(fontSize: 15.5, color: Colors.black),
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
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    backgroundImage: NetworkImage(widget.profilePicUrl),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: commentController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: 'leave a comment',
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  )
                ),
                TextButton(
                  onPressed: ()async{
                    await FirestoreService().postComment(
                      postId: widget.postId, 
                      comment: commentController.text, 
                      userId: widget.userUid, 
                      username: widget.username, 
                      profilePicUrl: widget.profilePicUrl,
                      context: context
                    );
                    setState(() {
                      commentController.clear();
                    });
                  }, 
                  child: const Text('Post')
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}