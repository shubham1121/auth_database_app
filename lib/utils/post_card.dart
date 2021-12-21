import 'package:auth_database_cart/models/post_data.dart';
import 'package:auth_database_cart/utils/database_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PostCard extends StatefulWidget {
  final PostData? postData;
  const PostCard({Key? key, this.postData}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final _databaseService = DatabaseService(user!.uid);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
      child: Card(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(widget.postData!.title),
                IconButton(onPressed: (){
                  setState(() {
                    _databaseService.deletePost(widget.postData);
                  });
                }, icon: const Icon(Icons.delete),),
              ],
            ),
            SizedBox(
              height: 300.0,
              child: ListView.builder(
                shrinkWrap: true,
                // physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: widget.postData!.uplImgLink.length,
                itemBuilder: (context,index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20.0),
                    child: Container(
                      width: 300,
                      // child: Image.network(widget.postData!.uplImgLink[index],
                      child: CachedNetworkImage(
                        imageUrl: widget.postData!.uplImgLink[index],
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.contain,
                      ),


                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

