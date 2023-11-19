import 'package:bangapp/widgets/buildBangUpdate2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bangapp/services/service.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/urls.dart';
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

class BangUpdate {
  final String filename;
  final String type;
  final String caption;
  final String userName;
  final String userImage;
  final int postId;
  bool isLiked;
  int likeCount;
  int commentCount;
  final int userId;

  BangUpdate({
    required this.filename,
    required this.type,
    required this.caption,
    required this.postId,
    required this.userName,
    required this.userImage,
    required this.likeCount,
    required this.isLiked,
    required this.commentCount,
    required this.userId
  });
}

class BangUpdateProvider extends ChangeNotifier {
  List<BangUpdate> _bangUpdates = [];

  List<BangUpdate> get bangUpdates => _bangUpdates;

  Future<void> fetchBangUpdates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id').toString();
    var response = await http.get(Uri.parse('$baseUrl/bang-updates/$userId'));
    print(response.body);
    var data = json.decode(response.body);
    print('$baseUrl/bang-updates/$userId');
    _bangUpdates = List<BangUpdate>.from(data.map((post) {
      return BangUpdate(
        filename: post['filename'],
        type: post['type'],
        caption:  post['caption'] ?? "" ,
        postId: post['id'],
        likeCount: post['bang_update_like_count'] != null &&
            post['bang_update_like_count'].isNotEmpty
            ? post['bang_update_like_count'][0]['like_count']
            : 0,
        userImage: post['user_image_url'] ,
        userName: post['user']['name'],
        commentCount: post['bang_update_comments'] != null &&
            post['bang_update_comments'].isNotEmpty
            ? post['bang_update_comments'][0]['comment_count']
            : 0,
        isLiked: post['isLiked'],
        userId: prefs.getInt('user_id')!,
      );
    }));

    notifyListeners();
  }
  void increaseLikes(int postId) {
    final bangUpdate =
        _bangUpdates.firstWhere((update) => update.postId == postId);
    if (bangUpdate.isLiked) {
      bangUpdate.likeCount--;
      bangUpdate.isLiked = false;
    } else {
      bangUpdate.likeCount++;
      bangUpdate.isLiked = true;
    }
    notifyListeners();
  }

  void updateCommentCount(int postId, int newCount) {
    final bangUpdate =
        _bangUpdates.firstWhere((update) => update.postId == postId);
    bangUpdate.commentCount++;
    notifyListeners();
  }
}



