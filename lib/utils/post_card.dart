import 'package:auth_database_cart/models/post_data.dart';
import 'package:auth_database_cart/screens/post_details_page.dart';
import 'package:auth_database_cart/utils/database_firestore.dart';
import 'package:auth_database_cart/utils/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PostCard extends StatefulWidget {
  final PostData postData;
  final bool isAllPost;
  User? current_user = FirebaseAuth.instance.currentUser;
  PostCard({Key? key, required this.postData, required this.isAllPost})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isPhotoView = false;
  @override
  Widget build(BuildContext context) {
    print(widget.current_user!.uid);
    final _databaseService = DatabaseService(widget.current_user!.uid);
    return widget.postData == null
        ? Loading(false)
        : Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(widget.postData.title),
                      Container(
                        child: widget.isAllPost
                            ? null
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    _databaseService
                                        .deletePost(widget.postData);
                                  });
                                },
                                icon: const Icon(Icons.delete),
                              ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: openPostDetails,
                    child: SizedBox(
                      height: 300.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.postData.uplImgLink.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20.0),
                            child: Container(
                              width: 300,
                              child: CachedNetworkImage(
                                imageUrl: widget.postData.uplImgLink[index],
                                placeholder: (context, url) =>
                                    smallLoadingIndicatorForImages(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  void openPostDetails() => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => PostDetails(
          postData: widget.postData,
        ),
      ));
}
//
// class GalleryPage extends StatefulWidget {
//   final PageController pageController;
//   final List<dynamic> urlImages;
//   final int index;
//   GalleryPage({required this.urlImages, this.index = 0})
//       : pageController = PageController(initialPage: index);
//
//   @override
//   State<GalleryPage> createState() => _GalleryPageState();
// }
//
// class _GalleryPageState extends State<GalleryPage> {
//   late int index = widget.index;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PhotoViewGallery.builder(
//         pageController: widget.pageController,
//         itemCount: widget.urlImages.length,
//         builder: (context, index) {
//           final urlImage = widget.urlImages[index];
//           return PhotoViewGalleryPageOptions(
//             imageProvider: NetworkImage(urlImage),
//             minScale: PhotoViewComputedScale.contained,
//             maxScale: PhotoViewComputedScale.contained * 2,
//           );
//         },
//         loadingBuilder: (context, event) => Center(
//           child: Container(
//             child: smallLoadingIndicatorForImages(),
//           ),
//         ),
//         onPageChanged: (index) => setState(() => this.index = index),
//       ),
//     );
//   }
// }
