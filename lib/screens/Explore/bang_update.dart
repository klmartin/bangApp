import 'package:bangapp/widgets/buildBangUpdate2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:bangapp/widgets/video_player_item.dart';
import '../../constants/urls.dart';
import '../../widgets/SearchBox.dart';
import '../Comments/updateComment.dart';
import 'bang_updates_like_button.dart';
import 'explore_page2.dart';

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

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final bangUpdateProvider = Provider.of<BangUpdateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SearchBox(),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount:bangUpdateProvider.bangUpdates.length,
              controller: PageController(initialPage: 0, viewportFraction: 1),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final data =  bangUpdateProvider.bangUpdates[index];
                return Stack(
                  children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Chemba ya Umbea".toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 4,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    VideoPlayerItem(videoUrl: data.filename, type:data.type),
                    Column(
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        data.caption,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,color: Colors.white),
                                      ),
                                      Text(
                                        data.caption,
                                        style: const TextStyle(fontSize: 16,color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 100,
                                margin: EdgeInsets.only(top: size.height / 5),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildProfile(logoUrl),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () =>
                                              BangUpdateLikeButton(
                                                  likeCount: data.likeCount,
                                                  isLiked: data.isLiked,
                                                  postId: data.postId),
                                          child: Icon(
                                              Icons.favorite,
                                              size: 40,
                                              color: data.isLiked ? Colors.red : Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 7),
                                        Text(
                                          data.likeCount.toString(),
                                          style: const TextStyle(fontSize: 20 ,color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateCommentsPage(
                                                      postId: data.postId, userId: 6,
                                                      // currentUser: 1,
                                                    ),
                                              )),
                                          child: const Icon(
                                            Icons.comment,
                                            size: 40,
                                          ),
                                        ),
                                        const SizedBox(height: 7),
                                        Text(
                                          data.commentCount.toString(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const InkWell(
                                          child: Icon(
                                            Icons.reply,
                                            size: 40,
                                          ),
                                        ),
                                        const SizedBox(height: 7),
                                        Text(
                                          data.commentCount.toString(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
