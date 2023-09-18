// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:provider/provider.dart';
// import '../constants/urls.dart';
// import '../models/post.dart';

// class HomeProvider extends ChangeNotifier {
//   bool _isLastPage = false;
//   int _pageNumber = 0;
//   bool _error = false;
//   bool _loading = true;
//   final int _numberOfPostsPerRequest = 10;
//   List<Post>? _posts;
//   final int _nextPageTrigger = 3;

//   bool get isLastPage => _isLastPage;
//   int get pageNumber => _pageNumber;
//   bool get error => _error;
//   bool get loading => _loading;
//   List<Post>? get posts => _posts;


//   Future<void> fetchData() async {
//     try {
//       final response = await get(Uri.parse(
//           "$baseUrl/getPosts?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest"));
//       final Map<String, dynamic> responseData = json.decode(response.body);
//       print(responseData);
//       if (responseData.containsKey('data')) {
//         List<dynamic> responseList = responseData['data']['data']; // Access the nested 'data' array
//         List<Post> postList = responseList.map((data) {
//           print(data);
//           List<dynamic>? challengesList = data['challenges']; // Add '?' to make it nullable
//           List<Challenge> challenges = (challengesList ?? []).map((challengeData) => Challenge(
//             id: challengeData['id'],
//             postId: challengeData['post_id'],
//             userId: challengeData['user_id'],
//             challengeImg: challengeData['challenge_img'],
//             body: challengeData['body'] ?? '',
//             type: challengeData['type'],
//             confirmed: challengeData['confirmed'],
//           )).toList();
//           return Post(
//             postId: data['id'],
//             userId: data['user_id'],
//             name: data['user']['name'],
//             image: data['image'],
//             challengeImg: data['challenge_img'],
//             caption: data['body'] ?? '',
//             type: data['type'],
//             width: data['width'],
//             height: data['height'],
//             likeCountA: data['like_count_A'],
//             likeCountB: data['like_count_B'],
//             commentCount: data['commentCount'],
//             followerCount: data['user']['followerCount'],
//             isLiked: data['isFavorited'] == 0 ? false : true ,
//             isPinned: data['pinned'],
//             challenges: challenges , // Pass the list of challenges to the Post constructor
//           );
//         }).toList();
//           _isLastPage = postList.length < _numberOfPostsPerRequest;
//           _loading = false;
//           _pageNumber = _pageNumber + 1;
//           _posts?.addAll(postList);
//       } else {
//           _loading = false;
//           _error = true;
//       }
//     } catch (e) {
//       errorDialog(size: 30);
//       // ... existing error handling ...
//     }
//   }



//   Widget errorDialog({required double size}) {
//     return SizedBox(
//       height: 180,
//       width: 200,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'An error occurred when fetching the posts.',
//             style: TextStyle(
//               fontSize: size,
//               fontWeight: FontWeight.w500,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           TextButton(
//             onPressed: () {
//               _loading = true;
//               _error = false;
//               fetchData();
//               notifyListeners();
//             },
//             child: const Text(
//               "Retry",
//               style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
