import 'package:flutter/material.dart';

class PostData{
  final String title;
  final String desc;
  final String userId;
  final String date;
  String postId ="";
  List<dynamic> uplImgLink = [];

  PostData(this.title, this.desc, this.userId, this.date);
}