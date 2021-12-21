import 'dart:io';
import 'package:auth_database_cart/models/post_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:auth_database_cart/models/our_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference allPostCollection =
      FirebaseFirestore.instance.collection('All Post');
  DatabaseService(this.uid);

  Future updateUserData(String name, String contactNo, String profession) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'contactNo': contactNo,
      'profession': profession,
    });
  }

  List<OurUser?> _ourUserListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return OurUser(
        name: doc.get('name') ?? "",
        contactNumber: doc.get('contactNo') ?? "",
        profession: doc.get('profession') ?? "",
      );
    }).toList();
  }

  Stream<List<OurUser?>> get userData => userCollection
      .snapshots()
      .map((snapshot) => _ourUserListfromSnapshot(snapshot));

  Future<String?> uploadImageFirebaseStorage(File img, PostData postData) async {
    late UploadTask uploadTask;
    try {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${path.basename(img.path)}');
      uploadTask = storageReference.putFile(img);
    } on FirebaseException catch (e) {
      print(e.message);
      return null;
    }
    if (uploadTask == null) {
      return null;
    }
    final snapshot = await uploadTask.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    return urlDownload;
  }

  // Future? addPost(PostData post) async {
  //   late String docID;
  //   String uploadResult = await allPostCollection.add({
  //     'title': post.title,
  //     'desc': post.desc,
  //     'upldate': post.date,
  //     'userId': uid,
  //   }).then((value) {
  //     docID = value.id;
  //     return "Success";
  //   }).catchError((error) => "Error Found");
  //   if (uploadResult == "Error Found") {
  //     return "Error";
  //   }
  //   final CollectionReference postImageCollection = FirebaseFirestore.instance
  //       .collection('All Post')
  //       .doc(docID)
  //       .collection('images');
  //   for (var imgLink in post.uplImgLink) {
  //     postImageCollection.add({
  //       'imgUrl': imgLink,
  //     });
  //   }
  // }

  Future? addPost(PostData post) async {
    String uploadResult = await allPostCollection.add({
      'title': post.title,
      'desc': post.desc,
      'upldate': post.date,
      'userId': uid,
      'postId' : "",
      'images': FieldValue.arrayUnion(post.uplImgLink),
    }).then((value) async{
       await allPostCollection.doc(value.id).update({
         'postId' : value.id.toString(),
       });
      return "Success";
    }).catchError((error) => "Error Found");
    if (uploadResult == "Error Found") {
      return "Error";
    }
  }

  List<String> _getImagesUrlList(QuerySnapshot imgSnapshot) {
    return imgSnapshot.docs.map((doc) {
      String url = doc.get('imgUrl');
      return url;
    }).toList();
  }

  List<PostData?>? _ourPostListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      PostData postData = PostData(doc.get('title'), doc.get('desc'),
          doc.get('userId'), doc.get('upldate'));
      postData.uplImgLink = doc.get('images');
      postData.postId=doc.get('postId');
      print(postData.uplImgLink);
      return postData;
    }).toList();
  }

  Stream<List<PostData?>?> get postData => allPostCollection
      .snapshots()
      .map((snapshot) => _ourPostListFromSnapshot(snapshot));

  Future? deletePost(PostData? postData) async
  { if(postData!=null)
    {
      for (var pD in postData.uplImgLink) {
        await FirebaseStorage.instance.refFromURL(pD).delete();
      }
      await allPostCollection
          .doc(postData.postId)
          .delete()
          .then((value) => "Deleted")
          .catchError((error) => "Error");
    }
    return null;
  }
}
