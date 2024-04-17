import 'package:bangapp/widgets/buildBangUpdate2.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/services/service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../nav.dart';
import '../../providers/bang_update_provider.dart';
import '../../providers/update_image_upload.dart';
import '../../providers/video_upload.dart';
import '../../widgets/SearchBox.dart';
import 'package:preload_page_view/preload_page_view.dart';
import '../Widgets/update_image_upload.dart';
import '../Widgets/video_upload.dart';

class BangUpdates2 extends StatefulWidget {
  @override
  _BangUpdates2State createState() => _BangUpdates2State();
}

class _BangUpdates2State extends State<BangUpdates2> {
  @override
  late VideoUploadProvider videoUploadProvider; // Declare it here
  late UpdateImageUploadProvider updateImageUploadProvider; // Declare it here

  void initState() {
    super.initState();
    final bangUpdateProvider =
        Provider.of<BangUpdateProvider>(context, listen: false);
    bangUpdateProvider.fetchBangUpdates();
    videoUploadProvider =
        Provider.of<VideoUploadProvider>(context, listen: false);
    updateImageUploadProvider =
        Provider.of<UpdateImageUploadProvider>(context, listen: false);

  }

  @override
  Widget build(BuildContext context) {
    final bangUpdateProvider =
        Provider.of<BangUpdateProvider>(context, listen: true);
    final updateImageUploadProvider2 =
        Provider.of<UpdateImageUploadProvider>(context, listen: true);
    final updateVideoUploadProvider2 =
    Provider.of<VideoUploadProvider>(context, listen: true);
    return bangUpdateProvider.isLoading
        ? Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Color(0xFFF40BF5), size: 30))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: SearchBox(),
            ),
            body: Column(
              children: [
                updateVideoUploadProvider2.isUploading ? VideoUpload() : Container(),
                updateImageUploadProvider2.isUploading ? UpdateImageUpload() : Container(),
                Expanded(
                  child: BangUpdates3(),
                ),
              ],
            ),
          );
  }
}

class BangUpdates3 extends StatefulWidget {
  @override
  _BangUpdates3State createState() => _BangUpdates3State();
}

class _BangUpdates3State extends State<BangUpdates3> {
  late BangUpdateProvider bangUpdateProvider;
  int currentIndex = 0;
  late VideoUploadProvider videoUploadProvider; // Declare it here
  late UpdateImageUploadProvider updateImageUploadProvider; // Declare it here

  void initState() {
    videoUploadProvider =
        Provider.of<VideoUploadProvider>(context, listen: false);
    updateImageUploadProvider =
        Provider.of<UpdateImageUploadProvider>(context, listen: false);

    videoUploadProvider.addListener(() {
      if (videoUploadProvider.uploadText == 'Upload Complete') {
        BangUpdateProvider().refreshUpdates();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Nav(initialIndex: 1)));
      }
    });

    updateImageUploadProvider.addListener(() {
      if (updateImageUploadProvider.uploadText == 'Upload Complete') {
        BangUpdateProvider().refreshUpdates();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Nav(initialIndex: 1)));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    bangUpdateProvider = Provider.of<BangUpdateProvider>(context,listen: true);
    return Stack(
      children: [
        PreloadPageView.builder(
          key: const PageStorageKey<String>('chemba'),
          preloadPagesCount: 3,
          scrollDirection: Axis.vertical,
          itemCount: bangUpdateProvider.bangUpdates.length,
          itemBuilder: (context, index) {
            final bangUpdate = bangUpdateProvider.bangUpdates[index];
            Service().updateBangUpdateIsSeen(bangUpdate.postId);
            return buildBangUpdate2(context, bangUpdate, index);
          },
          onPageChanged: (index) {
            final bangUpdateProvider = Provider.of<BangUpdateProvider>(context, listen: false);
            final bangUpdate = bangUpdateProvider.bangUpdates;
            final remainingItems = bangUpdate.length - index; // Calculate remaining items
            if (remainingItems <= 4) {
              bangUpdateProvider.getMoreUpdates();
            }
          },
        ),
      ],
    );
  }
}
