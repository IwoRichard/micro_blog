// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:micro_blog/providers/userDataProvider.dart';
import 'package:micro_blog/services/firestore_service.dart';
import 'package:micro_blog/utils/pickImage.dart';
import 'package:micro_blog/utils/snackbar.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  bool isLoading = false;
  TextEditingController postController = TextEditingController();
  Uint8List? image;

  @override
  void dispose() {
    super.dispose();
    postController.dispose();
  }

  void pickedimage()async{
    final imagee = await pickImage(ImageSource.gallery);
    setState(() {
      image = imagee;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .5,
        title: const Text(
          'Add Post',
          style: TextStyle(
            fontSize: 19, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87,)
        ),
        actions: [
          Consumer(
            builder: (context, WidgetRef ref, child) {
              final userData = ref.watch(userDataProvider(FirebaseAuth.instance.currentUser?.uid));
              return userData.when(
                data: (data){
                  return TextButton(
                    onPressed: ()async{
                      if(postController.text.isNotEmpty || image != null){
                        setState(() {
                          isLoading = true;
                        });
                        image != null ? await FirestoreService().uploadPostWithPicture(
                          file: image!, 
                          userUid: data.uid, 
                          username: data.username, 
                          profilePicUrl: data.profilePicUrl,
                          description: postController.text,
                          context: context
                        ): await FirestoreService().uploadPostNoPicture(
                          userUid: data.uid, 
                          username: data.username, 
                          profilePicUrl: data.profilePicUrl,
                          description: postController.text, 
                          context: context
                        );
                        setState(() {
                          isLoading = false;
                        });
                      }
                      Navigator.pop(context);
                    }, 
                    child: Text(
                      'Post',
                      style: TextStyle(color:Colors.blue.shade700,fontWeight: FontWeight.w600),
                    )
                  );
                }, 
                error: (error, _){
                  return snackBar('Error: Post Unsuccessful', context, Colors.red);
                }, 
                loading: (){
                  return Container();
                },
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isLoading ? const LinearProgressIndicator():Container(),
              Consumer(
                builder: (context, WidgetRef ref, child) {
                  final image = ref.watch(userDataProvider(FirebaseAuth.instance.currentUser?.uid));
                  return image.when(
                    data: (data){
                      return CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        backgroundImage: NetworkImage(data.profilePicUrl),
                      );
                    }, 
                    error: (error, _){
                      debugPrint(error.toString());
                      return CircleAvatar(backgroundColor: Colors.grey[100],);
                    }, 
                    loading: (){
                      return CircleAvatar(backgroundColor: Colors.grey[100],);
                    }
                  );
                }
              ),
              const SizedBox(height: 10,), 
              image != null ? ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: double.infinity,
                  maxHeight: MediaQuery.of(context).size.height/2
                ),
                child: Image.memory(image!, fit: BoxFit.cover,)) :
                InkWell(
                  onTap: pickedimage,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    strokeWidth: 1,
                    dashPattern: const [8,4],
                    radius: const Radius.circular(20),
                    color: Colors.blue.withOpacity(.5),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Iconsax.gallery_add, color: Colors.blue,),
                            const SizedBox(width: 5,),
                            const Text(
                              'Add Image',
                              style: TextStyle(color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                    )
                  ),
                ),
              const SizedBox(height: 5,),
              TextFormField(
                maxLines: null,
                controller: postController,
                keyboardType: TextInputType.multiline,
                cursorColor: Colors.blue.shade700,
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  hintStyle: TextStyle(fontSize: 20,color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none
                  ),
                  filled: false
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}