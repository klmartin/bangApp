import 'package:bangapp/widgets/buildBangUpdate2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/urls.dart';
import '../../services/animation.dart';
import '../../widgets/SearchBox.dart';
import '../Comments/updateComment.dart';
import 'bang_updates_like_button.dart';

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
    return Stack(
      children: [
        PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: bangUpdateProvider.bangUpdates.length,
          itemBuilder: (context, index) {
            final bangUpdate = bangUpdateProvider.bangUpdates[index];
            return Container(
              color: Colors.black,
              child: index != 0
                  ? FutureBuilder<Widget>(
                future: buildBangUpdate2(context, bangUpdate, index),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return snapshot.data ?? Container(); // Use the widget if available, or a fallback Container
                  } else {
                    return CircularProgressIndicator(); // Show a loading indicator while fetching the widget
                  }
                },
              )
                  : Column(
                children: [
                  FutureBuilder<Widget>(
                    future: buildBangUpdate2(context, bangUpdate, index),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return snapshot.data ?? Text("No Content Here, Please come again later");
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),


        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                VideoDescription('7', '8'), // Remove the quotes
                ActionsToolbar(2.toString(),5.toString(), logoUrl), // Remove the quotes
              ],
            ),
            SizedBox(height: 20)
          ],
        ),
      ],
    );
  }

}

class BangUpdate {
  final String filename;
  final String type;
  final String caption;
  final int postId;
  bool isLiked;
  int likeCount;
  int commentCount;

  BangUpdate({
    required this.filename,
    required this.type,
    required this.caption,
    required this.postId,
    required this.likeCount,
    required this.isLiked,
    required this.commentCount,
  });
}

class BangUpdateProvider extends ChangeNotifier {
  List<BangUpdate> _bangUpdates = [];

  List<BangUpdate> get bangUpdates => _bangUpdates;

  Future<void> fetchBangUpdates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id').toString();
    var response = await http.get(Uri.parse('$baseUrl/bang-updates/$userId'));

    var data = json.decode(response.body);
    print(data);
    _bangUpdates = List<BangUpdate>.from(data.map((post) {
      final filename = post['filename'];
      final type = post['type'];
      final caption = post['caption'] ?? "";
      final postId = post['id'];
      final isLiked = post['isLiked'];
      var likeCount = post['bang_update_like_count'] != null &&
              post['bang_update_like_count'].isNotEmpty
          ? post['bang_update_like_count'][0]['like_count']
          : 0;
      //   var likeCount = post['likeCount'];
      var commentCount = post['bang_update_comments'] != null &&
              post['bang_update_comments'].isNotEmpty
          ? post['bang_update_comments'][0]['comment_count']
          : 0;

      return BangUpdate(
        filename: filename,
        type: type,
        caption: caption ,
        postId: postId,
        likeCount: likeCount,
        commentCount: commentCount,
        isLiked: isLiked,
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
    print("hereeeeeeeeeeeee");
    print(postId);
    print(bangUpdate.commentCount);
    notifyListeners();
  }
}

class VideoDescription extends StatelessWidget {
  final username;
  final videtoTitle;

  VideoDescription(this.username, this.videtoTitle);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            height: 120.0,
            padding: EdgeInsets.only(left: 20.0),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '@' + username,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    videtoTitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ])));
  }
}

class ActionsToolbar extends StatelessWidget {
  // Full dimensions of an action
  static const double ActionWidgetSize = 60.0;

// The size of the icon showen for Social Actions
  static const double ActionIconSize = 35.0;

// The size of the share social icon
  static const double ShareActionIconSize = 25.0;

// The size of the profile image in the follow Action
  static const double ProfileImageSize = 50.0;

// The size of the plus icon under the profile image in follow action
  static const double PlusIconSize = 20.0;

  final String numLikes;
  final String numComments;
  final String userPic;

  ActionsToolbar(this.numLikes, this.numComments, this.userPic);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _getFollowAction(pictureUrl: userPic),
        SizedBox(height: 10),
        BangUpdateLikeButton(
            likeCount: 1,
            isLiked: true,
            postId:6
        ),
        Text(
          7.toString(),
          style: TextStyle(
            fontSize: 12.5,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              createRoute(
                UpdateCommentsPage(
                  postId: 6, userId: 6,
                  // currentUser: 1,
                ),
              ),
            );
          },
          child: Icon(
            CupertinoIcons.chat_bubble,
            color: Colors.white,
            size: 30,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "${34}",
          style: TextStyle(
            fontSize: 12.5,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Icon(CupertinoIcons.paperplane,
            color: Colors.white, size: 30),
      ]),
    );
  }


  Widget _getFollowAction({required String pictureUrl}) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        width: 60.0,
        height: 60.0,
        child:
        Stack(children: [_getProfilePicture(pictureUrl)]));
  }

  Widget _getProfilePicture(userPic) {
    return Positioned(
        left: (ActionWidgetSize / 2) - (ProfileImageSize / 2),
        child: Container(
            padding:
            EdgeInsets.all(1.0), // Add 1.0 point padding to create border
            height: ProfileImageSize, // ProfileImageSize = 50.0;
            width: ProfileImageSize, // ProfileImageSize = 50.0;
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ProfileImageSize / 2)),
            // import 'package:cached_network_image/cached_network_image.dart'; at the top to use CachedNetworkImage
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: CachedNetworkImage(
                  imageUrl: userPic,
                  placeholder: (context, url) =>
                  new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ))));
  }

  LinearGradient get musicGradient => LinearGradient(colors: [
    Colors.grey[800]!,
    Colors.grey[900]!,
    Colors.grey[900]!,
    Colors.grey[800]!
  ], stops: [
    0.0,
    0.4,
    0.6,
    1.0
  ], begin: Alignment.bottomLeft, end: Alignment.topRight);

}

