import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:micro_blog/providers/commentsProvider.dart';
import 'package:micro_blog/providers/postProvider.dart';
import '../screens/PrimaryScreens/profile_screen.dart';
import '../screens/SecondaryScreens/view_post_picture.dart';
import '../services/firestore_service.dart';
import 'action_icons.dart';

class PostCard extends ConsumerStatefulWidget {
  final String userUid;
  final String username;
  final String profilePicUrl;
  final String description;
  final  String postImageUrl;
  final String postId;
  final datePosted;
  final List likes;
  final bool isAndroid;
  const PostCard({
    Key? key,
    required this.userUid,
    required this.username,
    required this.profilePicUrl,
    required this.postId,
    required this.likes, 
    required this.description, 
    required this.postImageUrl, 
    this.datePosted,
    required this.isAndroid
  }) : super(key: key);

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(commentsProvider(widget.postId));
    final comment = comments.value??[];
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
      child: Card(
        elevation: 0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context)=> ViewPostPicture(
                      image: widget.profilePicUrl, 
                      tag: widget.userUid
                    )
                  )
                );
              },
              child: GestureDetector(
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
                  backgroundImage: NetworkImage(widget.profilePicUrl),
                  radius: 26,
                  backgroundColor: Colors.grey[100],
                ),
              ),
            ),
            const SizedBox(width: 7,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Container(
                        height: 4,
                        width: 4,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle
                        ),
                      ),
                      const SizedBox(width: 5,),
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
                  if(widget.description != "")
                  const SizedBox(height: 7,),
                  if(widget.description != "")
                  Text(
                    widget.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15.5),
                  ),
                  if(widget.postImageUrl != "")
                  const SizedBox(height: 7,),
                  if(widget.postImageUrl != "")
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context)=> ViewPostPicture(image: widget.postImageUrl, tag: widget.postId,)
                        )
                      );
                    },
                    child: Hero(
                      tag: widget.postId,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(widget.postImageUrl, errorBuilder: (context, error, stackTrace) {
                          return Container();
                        },),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
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
                        number: widget.likes.length.toString(), 
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
                        number: comment.length.toString(),//'5', 
                        icon: const Icon(
                          Iconsax.message,
                          color: Colors.grey,
                          size: 20,
                        )
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}