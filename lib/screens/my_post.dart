import 'package:auth_database_cart/models/post_data.dart';
import 'package:auth_database_cart/utils/loading.dart';
import 'package:auth_database_cart/utils/post_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPostList extends StatefulWidget {
  const MyPostList({Key? key}) : super(key: key);

  @override
  _MyPostListState createState() => _MyPostListState();
}

class _MyPostListState extends State<MyPostList> {
  @override
  Widget build(BuildContext context) {
    final List<PostData?>? userPostlist =
        Provider.of<List<PostData?>?>(context);
    if (userPostlist == null) {
      return Loading(false);
    }
    List<PostData> userNonNullPostList =
        List.from(userPostlist.where((time) => time != null));
    return userNonNullPostList == null
        ? Loading(false)
        : userNonNullPostList.length == 0
            ? Center(child: Text('No List'))
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: userNonNullPostList.length,
                itemBuilder: (context, index) {
                  print(userNonNullPostList.length);
                  return PostCard(
                      postData: userNonNullPostList[index], isAllPost: false);
                },
              );
  }
}
