import 'package:bangapp/widgets/buildBangUpdate2.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/services/service.dart';
import 'package:provider/provider.dart';
import '../../loaders/bang_update_skeleton.dart';
import '../../providers/bang_update_provider.dart';
import '../../providers/update_video_upload.dart';
import '../../widgets/SearchBox.dart';
import 'package:preload_page_view/preload_page_view.dart';

import '../Widgets/update_video_upload.dart';

class BangUpdates2 extends StatefulWidget {
  @override
  _BangUpdates2State createState() => _BangUpdates2State();
}

class _BangUpdates2State extends State<BangUpdates2> {
  @override

  void initState() {
    super.initState();
    final bangUpdateProvider =
        Provider.of<BangUpdateProvider>(context, listen: false);
    bangUpdateProvider.fetchBangUpdates();
  }

  @override
  Widget build(BuildContext context) {
    final bangUpdateProvider =
        Provider.of<BangUpdateProvider>(context, listen: true);
    final updateVideoUploadProvider =
        Provider.of<UpdateVideoUploadProvider>(context, listen: false);
    return bangUpdateProvider.isLoading
        ? BangUpdateSkeleton()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: SearchBox(),
            ),
            body: Column(
              children: [
                updateVideoUploadProvider.isUploading ? UpdateVideoUpload() : Container(),
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

  @override
  Widget build(BuildContext context) {
    bangUpdateProvider = Provider.of<BangUpdateProvider>(context,listen: true);
    return Stack(
      children: [
        PreloadPageView.builder(
          key: const PageStorageKey<String>('chemba'),
          controller: PreloadPageController(),
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
