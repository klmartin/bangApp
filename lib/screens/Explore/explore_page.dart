// import 'package:flutter/material.dart';
// import 'package:bangapp/widgets/SearchBox.dart';
// import 'package:bangapp/widgets/buildBangUpdate.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import "package:bangapp/services/service.dart";



// class Explore extends StatefulWidget {
//   @override
//   _ExploreState createState() => _ExploreState();
// }

// class _ExploreState extends State<Explore> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//     appBar:AppBar(
//         backgroundColor: Colors.white,
//         title:SearchBox()
//     ),
//     body: Column(
//       children: [
//         Expanded(
//           child: BangUpdates(),
//         ),
//       ],
//     )
//     );
//   }
// }

// class BangUpdates extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Service().getBangUpdates2(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (snapshot.data == null) {
//           return Text('No data available');
//         }
//         if (snapshot.data is List) {
//           final List<dynamic> dataList = snapshot.data as List<dynamic>;
//           return PageView.builder(
//             scrollDirection: Axis.vertical,
//             itemCount: dataList.length,
//             itemBuilder: (context, index) {
//               final post = dataList[index];
//               final filename = post['filename'];
//               final type = post['type'];
//               final caption = post['caption'];
//               final postId = post['id'];
//               var likeCount = post['bang_update_likes'] != null && post['bang_update_likes'].isNotEmpty ? post['bang_update_likes'][0]['like_count'] : 0;
//               return  Container(
//                   color: Colors.black,
//                   child: AspectRatio(
//                     aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
//                     child: buildBangUpdate(context, filename, type, caption, postId, likeCount,index),
//                   ),
//               );
//             },
//             controller: PageController(),
//           );
//         } else {
//           return Container();
//         }
//       },

//     );

//   }
// }





