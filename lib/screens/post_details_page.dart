import 'package:auth_database_cart/models/post_data.dart';
import 'package:auth_database_cart/utils/device_size.dart';
import 'package:auth_database_cart/utils/firebase_auth.dart';
import 'package:auth_database_cart/utils/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PostDetails extends StatefulWidget {
  final PostData postData;
  const PostDetails({Key? key, required this.postData}) : super(key: key);

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Details'),
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
      body: Column(
        children: [
          Container(
            child: SizedBox(
              height: 350.0,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.postData.uplImgLink.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          openDetails(index);
                        });
                      },
                      child: SizedBox(
                        width: 350,
                        child: CachedNetworkImage(
                          imageUrl: widget.postData.uplImgLink[index],
                          placeholder: (context, url) =>
                              smallLoadingIndicatorForImages(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.postData.title.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        widget.postData.date.substring(0, 10),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                          fontSize: displayWidth(context) * 0.05,
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        widget.postData.desc,
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void openDetails(int index) => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => GalleryPage(
          urlImages: widget.postData.uplImgLink,
          index: index,
        ),
      ));
}

class GalleryPage extends StatefulWidget {
  final PageController pageController;
  final List<dynamic> urlImages;
  final int index;
  GalleryPage({required this.urlImages, this.index = 0})
      : pageController = PageController(initialPage: index);

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late int index = widget.index;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        backgroundDecoration: const BoxDecoration(
          color: Colors.white,
        ),
        pageController: widget.pageController,
        itemCount: widget.urlImages.length,
        builder: (context, index) {
          final urlImage = widget.urlImages[index];
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(urlImage),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.contained * 2,
          );
        },
        loadingBuilder: (context, event) => Center(
          child: Container(
            child: smallLoadingIndicatorForImages(),
          ),
        ),
        onPageChanged: (index) => setState(() => this.index = index),
      ),
    );
  }
}
