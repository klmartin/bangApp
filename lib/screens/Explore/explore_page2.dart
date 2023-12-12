import 'package:bangapp/widgets/buildBangUpdate2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

class BangUpdates3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bangUpdateProvider = Provider.of<BangUpdateProvider>(context);
    return PreloadPageView.builder(
      controller: PreloadPageController(),
      preloadPagesCount: 3,
      scrollDirection: Axis.vertical,
      itemCount: bangUpdateProvider.bangUpdates.length,
      itemBuilder: (context, index) {
        final bangUpdate = bangUpdateProvider.bangUpdates[index];
        Service().updateBangUpdateIsSeen(bangUpdate.postId);
        return FutureBuilder<Widget>(
          future: buildBangUpdate2(context, bangUpdate, index),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.data ?? Container(); // Use the widget if available, or a fallback Container
            } else {
              // Loading indicator or placeholder while content is being loaded
              return CircularProgressIndicator();
            }
          },
        );
      },
    );
  }

}

