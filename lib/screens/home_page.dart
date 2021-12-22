import 'package:auth_database_cart/models/our_user.dart';
import 'package:auth_database_cart/screens/all_post.dart';
import 'package:auth_database_cart/screens/create_post_page.dart';
import 'package:auth_database_cart/screens/my_post_page.dart';
import 'package:auth_database_cart/utils/database_firestore.dart';
import 'package:auth_database_cart/utils/firebase_auth.dart';
import 'package:auth_database_cart/utils/loading.dart';
import 'package:auth_database_cart/utils/user_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final List<Widget> _children =  [
    const UserList(),
    CreatePostPage(),
    const AllPosts(),
     MyPostPage(),
  ];
  int _current_index = 0;
  void onTabTapped(int index) {
    setState(() {
      _current_index = index;
    });
  }

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
                // floatingActionButton: FloatingActionButton(
                //   child: const Icon(Icons.add),
                //   onPressed: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => CreatePostPage(user: user),
                //     ),
                //   ),
                // ),
                // body: const UserList(),
                body: _children[_current_index],
                bottomNavigationBar: SalomonBottomBar(
                  currentIndex: _current_index,
                  onTap: onTabTapped,
                  items:  [
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.home),
                      title: const Text('Home'),
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.add_box_outlined),
                      title: const Text('Create Post'),
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.all_inbox),
                      title: const Text('All Post'),
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.person),
                      title: const Text('My Post'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
