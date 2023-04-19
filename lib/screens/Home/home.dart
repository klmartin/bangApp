import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nallagram/models/story_view_model.dart';
// import 'package:nallagram/screens/create_page.dart';
// import 'package:nallagram/nav.dart';
// import 'package:nallagram/screens/profile.dart';
import 'package:like_button/like_button.dart';
import 'package:nallagram/widgets/story_widget.dart';
import '../../widgets/post_card.dart';
import '../Comments/commentspage.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import '../data.dart';
import 'package:http/http.dart' as http;


final _firestore = FirebaseFirestore.instance;

List<String> likedusers = [];

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SizedBox spacing() {
    return SizedBox(
      width: 15.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      spacing(),
                      StoryWid(
                          img: StoryViewData[0].img,
                          name: StoryViewData[0].name),
                      spacing(),
                      StoryWid(
                          img: StoryViewData[1].img,
                          name: StoryViewData[1].name),
                      spacing(),
                      StoryWid(
                          img: StoryViewData[2].img,
                          name: StoryViewData[2].name),
                      spacing(),
                      StoryWid(
                          img: StoryViewData[3].img,
                          name: StoryViewData[3].name),
                      spacing(),
                      StoryWid(
                          img: StoryViewData[4].img,
                          name: StoryViewData[4].name),
                      spacing(),
                      StoryWid(
                          img: StoryViewData[5].img,
                          name: StoryViewData[5].name),
                      spacing(),
                      StoryWid(
                          img: StoryViewData[6].img,
                          name: StoryViewData[6].name),
                      spacing(),
                      StoryWid(
                          img: StoryViewData[7].img,
                          name: StoryViewData[7].name),
                      spacing(),
                      StoryWid(
                          img: StoryViewData[8].img,
                          name: StoryViewData[8].name),
                      spacing(),
                      StoryWid(
                          img: StoryViewData[9].img,
                          name: StoryViewData[9].name),
                      spacing(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          PostStream(),
        ],
      ),
    ]);
  }
}

// class PostStream extends StatelessWidget {
//
//   Future<List<dynamic>> getPosts() async {
//     var response = await http.get(Uri.parse('http://192.168.100.113/social-backend-laravel/api/getAllPosts'));
//     var data = json.decode(response.body);
//     return data['posts'];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: getPosts(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(
//               backgroundColor: Colors.lightBlue,
//             ),
//           );
//         }
//
//         List<Widget> postCards = [];
//
//         for (var post in snapshot.data) {
//           final caption = post['caption'];
//           final imgurl = post['imgurl'];
//           final challengeImgUrl = post['challengeImgUrl'];
//
//           if (challengeImgUrl != null) {
//             postCards.add(Row(
//               children: [
//                 Container(
//                   width: MediaQuery.of(context).size.width * 0.45,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(imgurl),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Container(
//                   width: MediaQuery.of(context).size.width * 0.45,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(challengeImgUrl),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ],
//             ));
//           } else {
//             postCards.add(Container(
//               width: MediaQuery.of(context).size.width,
//               height: 200,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: NetworkImage(imgurl),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ));
//           }
//         }
//
//         return ListView(
//           shrinkWrap: true,
//           physics: ClampingScrollPhysics(),
//           children: postCards.reversed.toList(),
//         );
//       },
//     );
//   }
// }

class PostStream extends StatelessWidget {
  Future<List<dynamic>> getPosts() async {
    var response = await http.get(Uri.parse('http://192.168.151.229/social-backend-laravel/api/getAllPosts'));
    var data = json.decode(response.body);
    return data['posts'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPosts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlue,
            ),
          );
        }

        List<Widget> postCards = [];

        for (var post in snapshot.data) {
          final caption = post['caption'];
          final imgurl = post['imgurl'];
          final challengeImgUrl = post['challengeImgUrl'];

          if (challengeImgUrl != null) {
            postCards.add(Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imgurl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(challengeImgUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ));
          } else {
            postCards.add(PostCard(

              likes: 123,
            ));
          }
        }

        return ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: postCards.reversed.toList(),
        );
      },
    );
  }
}

