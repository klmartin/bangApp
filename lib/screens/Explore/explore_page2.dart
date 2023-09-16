import 'package:bangapp/widgets/buildBangUpdate2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/urls.dart';
import '../../widgets/SearchBox.dart';
import '../../widgets/buildBangUpdate.dart';

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
        backgroundColor: Colors.white,
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
    // Note: You don't need to call fetchBangUpdates here, as it's already called in initState.

    return Column(
      children: [
        Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.black
            ),
            child:  Text("Chemba ya Umbea",
            textAlign: TextAlign.center,
            style: TextStyle(

                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Metropolis',
                letterSpacing: -1)),
        ),

        Expanded(
          // Wrap the ListView.builder with an Expanded widget
          child: Consumer<BangUpdateProvider>(
            builder: (context, bangUpdateProvider, child) {
              return ListView.builder(
                itemCount: bangUpdateProvider.bangUpdates.length,
                itemBuilder: (context, index) {
                  final bangUpdate = bangUpdateProvider.bangUpdates[index];
                    return buildBangUpdate2(
                   context, bangUpdate,index,
                    // context, bangUpdate.filename, bangUpdate.type, bangUpdate.caption, bangUpdate.postId, bangUpdate.likeCount, index+1


                    );
                //   return buildBangUpdate2(context, bangUpdate, index);
                },
              );
            },
          ),
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
  int likeCount;
  int commentCount;

  BangUpdate({
    required this.filename,
    required this.type,
    required this.caption,
    required this.postId,
    required this.likeCount,
    required this.commentCount,
  });
}

class BangUpdateProvider extends ChangeNotifier {
  List<BangUpdate> _bangUpdates = [];

  List<BangUpdate> get bangUpdates => _bangUpdates;

  Future<void> fetchBangUpdates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     final userId = prefs.getInt('user_id').toString();
    try {
      var response = await http.get(Uri.parse(
      'https://alitaafrica.com/social-backend-laravel/api/bang-updates/$userId'));
      var data = json.decode(response.body);
      print('https://alitaafrica.com/social-backend-laravel/api/bang-updates');
      _bangUpdates = List<BangUpdate>.from(data.map((post) {
        final filename = post['filename'];
        final type = post['type'];
        final caption = post['caption'];
        final postId = post['id'];
        var likeCount = post['bang_update_likes'] != null &&
                post['bang_update_likes'].isNotEmpty
            ? post['bang_update_likes'][0]['like_count']
            : 0;
        var commentCount = post['bang_update_comments'] != null &&
                post['bang_update_comments'].isNotEmpty
            ? post['bang_update_comments'][0]['comment_count']
            : 0;

        return BangUpdate(
          filename: filename,
          type: type,
          caption: caption,
          postId: postId,
          likeCount: likeCount,
          commentCount: commentCount,
        );
      }));

      notifyListeners();
    } catch (error) {
      print('Error fetching Bang Updates: $error');
    }
  }

  void increaseLikes(int postId) {
    final bangUpdate =
        _bangUpdates.firstWhere((update) => update.postId == postId);
    bangUpdate.likeCount++;

    notifyListeners();
  }

  void updateCommentCount(int postId, int newCount) {
    final bangUpdate =
        _bangUpdates.firstWhere((update) => update.postId == postId);
    bangUpdate.commentCount++;

    notifyListeners();
  }
}

// class BuildBangUpdate extends StatelessWidget {
//   final BangUpdate bangUpdate;
//   final int index;

//   const BuildBangUpdate({
//     required this.bangUpdate,
//     required this.index,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bangUpdateProvider = Provider.of<BangUpdateProvider>(context);

//     return Text(bangUpdate.caption);
//   }
// }

// class SearchBox extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//    return Text("");
//   }
// }
