import 'dart:io';
import 'package:auth_database_cart/models/post_data.dart';
import 'package:auth_database_cart/utils/database_firestore.dart';
import 'package:auth_database_cart/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auth_database_cart/utils/device_size.dart';
import 'package:auth_database_cart/utils/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreatePostPage extends StatefulWidget {
  final user;
   CreatePostPage({Key? key, this.user}) : super(key: key);
  User? current_user = FirebaseAuth.instance.currentUser; // to get current firebase user
    @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late String userid;
  final AuthService _authService = AuthService();
  bool uploading = false;
  late DatabaseService _databaseService ;
  final _picker = ImagePicker();
  TextEditingController postDesc = TextEditingController();
  TextEditingController postTitle = TextEditingController();
  final _postFormKey = GlobalKey<FormState>();
  List<File> _image = [];
  List<String> uplImgLink = [];
  DateTime now = DateTime.now();
  late DateTime date;


  @override
  void initState() {
    super.initState();
    userid = widget.user.uid;
    _databaseService = DatabaseService(userid);
    date = DateTime(now.year, now.month, now.day);
  }

  chooseImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 50);
    if(pickedImage==null)
      {return;}
    setState(() {
      _image.add(File(pickedImage.path));
    });
    if (pickedImage.path == null) {
      retrieveLostData();
    }
  }


  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response == null) {
      print('Null Response Error');
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    }
  }

  Future<void> uploadFile() async {
    setState(() {
      uploading=true;
    });
    PostData post = PostData(postTitle.text.toString(), postDesc.text.toString(), widget.user.uid, date.toLocal().toString());
    for (var img in _image) {
      String? result = await _databaseService.uploadImageFirebaseStorage(img,post);
      if (result == null) {
        print('Null Result Error');
      }
      // uplImgLink.add(result!);
      post.uplImgLink.add(result!);
    }
    String? uplResult = await _databaseService.addPost(post);
    if(uplResult=="Error")
      {
       return uploadFile();
      }
    else {
      uplImgLink.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final uplImg = Provider.of<UploadedImages>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Home Page'),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _authService.logout();
                });
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: uploading ?  Loading(true) : ListView(
          children: [
            Column(
              children: [
                Form(
                  key: _postFormKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 25),
                    child: Column(
                      children: [
                        TextFormField(
                          style: TextStyle(
                            fontSize:
                                getOrientation(context) == Orientation.portrait
                                    ? displayWidth(context) * 0.045
                                    : displayHeight(context) * 0.045,
                          ),
                          autofocus: false,
                          controller: postTitle,
                          decoration: const InputDecoration(
                            hintText: 'Enter Title of the Post',
                            labelText: 'Title',
                          ),
                        ),
                        TextFormField(
                          style: TextStyle(
                            fontSize:
                                getOrientation(context) == Orientation.portrait
                                    ? displayWidth(context) * 0.045
                                    : displayHeight(context) * 0.045,
                          ),
                          autofocus: false,
                          controller: postDesc,
                          decoration: const InputDecoration(
                            hintText: 'Enter Description of the Post',
                            labelText: 'Description',
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: _image.length + 1,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemBuilder: (context, index) {
                            return index == 0
                                ? Center(
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          chooseImage();
                                        });
                                      },
                                      icon: const Icon(Icons.add),
                                    ),
                                  )
                                : Container(
                                    margin: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: FileImage(_image[index - 1]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                          },
                        ),
                        ElevatedButton(onPressed: (){
                          setState(() {
                            uploadFile().whenComplete(() => Navigator.of(context).pop());
                          });
                        }, child: const Text('Upload'),),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
