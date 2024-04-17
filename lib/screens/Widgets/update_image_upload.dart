import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/update_image_upload.dart';

class UpdateImageUpload extends StatefulWidget {
  @override
  _UpdateImageUploadState createState() => _UpdateImageUploadState();
}

class _UpdateImageUploadState extends State<UpdateImageUpload> {
  @override
  void initState()  {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final imageUploadProvider = Provider.of<UpdateImageUploadProvider>(context);
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

