import 'package:auth_database_cart/models/our_user.dart';
import 'package:auth_database_cart/screens/all_post.dart';
import 'package:auth_database_cart/screens/create_post_page.dart';
import 'package:auth_database_cart/screens/wrapper.dart';
import 'package:auth_database_cart/utils/database_firestore.dart';
import 'package:auth_database_cart/utils/firebase_auth.dart';
import 'package:auth_database_cart/utils/loading.dart';
import 'package:auth_database_cart/utils/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
   const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return SafeArea(
      child: user == null
          ? Loading(false)
          : StreamProvider<List<OurUser?>?>.value(
              value: DatabaseService(user.uid).userData,
              initialData: null,
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text('Home Page'),
                  actions: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          print(user);
                          _authService.logout();
                        });
                      },
                      icon: const Icon(Icons.logout),
                    ),
                  ],
                ),
                // floatingActionButton: FloatingActionButton(
                //   child: const Icon(Icons.add),
                //   onPressed: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => CreatePostPage(user: user),
                //     ),
                //   ),
                // ),
                body: const UserList(),
              ),
            ),
    );
  }
}
