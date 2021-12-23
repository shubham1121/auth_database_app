import 'package:auth_database_cart/models/post_data.dart';
import 'package:auth_database_cart/utils/loading.dart';
import 'package:auth_database_cart/utils/post_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllPostList extends StatefulWidget {
  const AllPostList({Key? key}) : super(key: key);

  @override
  State<AllPostList> createState() => _AllPostListState();
}

class _AllPostListState extends State<AllPostList> {
  @override
  Widget build(BuildContext context) {
    final List<PostData?>? allPostlist = Provider.of<List<PostData?>?>(context);
    if (allPostlist == null) {
      return Loading(false);
    }
    final List<PostData> allNonNullPostList =
        List.from(allPostlist.where((postData) => postData != null));
    return allNonNullPostList == null
        ? Loading(false)
        : allNonNullPostList.isEmpty
            ? const Center(child: Text('No List'))
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: allNonNullPostList.length,
                itemBuilder: (context, index) {
                  return PostCard(
                      postData: allNonNullPostList[index], isAllPost: true);
                },
              );
  }
}
