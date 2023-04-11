import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:micro_blog/utils/snackbar.dart';

class ViewPostPicture extends StatefulWidget {
  final String image;
  final String tag;
  const ViewPostPicture({
    Key? key,
    required this.image,
    required this.tag,
  }) : super(key: key);

  @override
  State<ViewPostPicture> createState() => _ViewPostPictureState();
}

class _ViewPostPictureState extends State<ViewPostPicture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black,)
        ),
        actions: [
          TextButton(
            onPressed: (){
              saveImage();
            }, 
            child: Text(
              'Save',
              style: TextStyle(color:Colors.blue.shade700,fontWeight: FontWeight.w600),
            )
          )
        ],
      ),
      body: Center(
        child: Hero(
          tag: widget.tag,
          child: Image(image: NetworkImage(widget.image))),
      ),
    );
  }

  saveImage() async {
    var response = await Dio().get(widget.image, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(response.data);
    if (result != null) {
      snackBar('Downloaded', context, Colors.green);
    } else {
      snackBar('Error downloading image', context, Colors.red);
    }
  }
}