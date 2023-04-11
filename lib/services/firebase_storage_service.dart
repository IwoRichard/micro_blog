import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService{
   FirebaseAuth firebaseAuth = FirebaseAuth.instance;
   FirebaseStorage firebaseStorage = FirebaseStorage.instance;

   Future<String> uploadPic(Uint8List file, String child, bool isPost)async{
    Reference ref = firebaseStorage.ref().child(child).child(firebaseAuth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
   }
}