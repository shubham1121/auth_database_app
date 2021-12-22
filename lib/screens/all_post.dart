import 'package:auth_database_cart/models/post_data.dart';
import 'package:auth_database_cart/utils/database_firestore.dart';
import 'package:auth_database_cart/utils/firebase_auth.dart';
import 'package:auth_database_cart/utils/all_post_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllPosts extends StatefulWidget {
  const AllPosts({Key? key}) : super(key: key);

  @override
  State<AllPosts> createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return SafeArea(
      child: StreamProvider<List<PostData?>?>.value(
        value: DatabaseService(user!.uid).postData,
        initialData: null,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('All Posts'),
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
          body: const AllPostList(),
        ),
      ),
    );
  }
}
