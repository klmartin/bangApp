import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../nav.dart';

import '../../providers/image_upload.dart';

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {

  @override
  void initState()  {
    super.initState();

  }

  @override

  Widget build(BuildContext context) {
    final imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return Container(
      height: 25,
      child: Column(
        children: [
          LinearProgressIndicator(
            color: Colors.red,
            backgroundColor: Colors.black,
          ),
          Text(imageUploadProvider.uploadText)
        ],
      ),
    );
  }



}

