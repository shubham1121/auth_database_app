import 'package:auth_database_cart/models/post_data.dart';
import 'package:auth_database_cart/screens/my_post.dart';
import 'package:auth_database_cart/utils/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auth_database_cart/utils/database_firestore.dart';
import 'package:provider/provider.dart';

class MyPostPage extends StatefulWidget {
  const MyPostPage({Key? key}) : super(key: key);

  @override
  _MyPostPageState createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return SafeArea(
        child: StreamProvider<List<PostData?>?>.value(
      value: DatabaseService(user!.uid).userPostData,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('My Posts'),
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
        body: MyPostList(),
      ),
    ));
  }
}
