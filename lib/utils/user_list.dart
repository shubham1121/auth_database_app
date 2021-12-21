import 'package:auth_database_cart/models/our_user.dart';
import 'package:auth_database_cart/screens/all_post.dart';
import 'package:auth_database_cart/screens/create_post_page.dart';
import 'package:auth_database_cart/utils/loading.dart';
import 'package:auth_database_cart/utils/user_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final List<OurUser?>? userlist = Provider.of<List<OurUser?>?>(context);
    return userlist == null
        ? Loading(false)
        : Column(

            children: [
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: userlist.length,
                itemBuilder: (context, index) {
                  return UserTile(user: userlist[index]);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllPosts(),
                              ),
                            ),
                        child: const Text('All Post')),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatePostPage(user: user,),
                        ),
                      ),
                      child: const Text('Create New Post'),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
