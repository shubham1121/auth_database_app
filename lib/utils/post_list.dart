import 'package:auth_database_cart/models/post_data.dart';
import 'package:auth_database_cart/utils/loading.dart';
import 'package:auth_database_cart/utils/post_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostList extends StatefulWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {

  @override
  Widget build(BuildContext context) {
    final List<PostData?>? postlist = Provider.of<List<PostData?>?>(context);
    return postlist==null ? Loading(false) : postlist.length == 0 ? Center(child: Text('No List')) : ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: postlist.length,
      itemBuilder: (context, index) {
        return PostCard(postData: postlist[index]);
      },
    );
  }
}


