import 'package:bangapp/widgets/buildBangUpdate2.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/services/service.dart';
import 'package:provider/provider.dart';
import '../../providers/bang_update_provider.dart';
import '../../widgets/SearchBox.dart';
import 'package:preload_page_view/preload_page_view.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: SearchBox(),
      ),
      body: Column(
        children: [
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
    bangUpdateProvider = Provider.of<BangUpdateProvider>(context);
    return PreloadPageView.builder(
      key: const PageStorageKey<String>('chemba'),
      controller: PreloadPageController(),
      preloadPagesCount: 3,
      scrollDirection: Axis.vertical,
      itemCount: bangUpdateProvider.bangUpdates.length,
      itemBuilder: (context, index) {
        final bangUpdate = bangUpdateProvider.bangUpdates[index];
        // Service().updateBangUpdateIsSeen(bangUpdate.postId);
        return buildBangUpdate2(context, bangUpdate, index);
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }


}


