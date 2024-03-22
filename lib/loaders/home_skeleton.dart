import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:bangapp/screens/Widgets/post_item2.dart';
import 'package:bangapp/providers/posts_provider.dart'; // Import your PostsProvider class
import 'package:provider/provider.dart';
import 'package:bangapp/models/post.dart';
class HomeSkeleton extends StatefulWidget {
  const HomeSkeleton();

  @override
  State<HomeSkeleton> createState() => _HomeSkeletonPageState();
}

class _HomeSkeletonPageState extends State<HomeSkeleton> {
  bool _enabled = true;

  List<Map<String, dynamic>> postData = [
    {
      "id": 908,
      "user_id": 13,
      "body": "noma",
      "type": "image",
      "image": "https://bangapp.pro/BangAppBackend/storage/app/images/NsjPlTw6WQC596RPsTRy7u1iil8ArMASagJqdR5s.jpg",
      "challenge_img": null,
      "aspect_ratio": null,
      "cache_url": null,
      "thumbnail_url": null,
      "pinned": 1,
      "is_seen": 0,
      "public_id": null,
      "created_at": "1 day ago",
      "price": "1000.00",
      "post_views_count": 1,
      "width": 300,
      "height": 300,
      "isLikedA": false,
      "isLikedB": false,
      "isLiked": false,
      "like_count_A": 0,
      "like_count_B": 0,
      "favoriteCount": 0,
      "isFavorited": 0,
      "commentCount": 0,
      "user_image_url":
          "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/ZnFXIuJj96hKdQe8Y6RTo2t6OJDTyhd1LznhgICH.jpg",
      "user": {
        "id": 13,
        "name": "Ghost",
        "image":
            "profile_pictures/ZnFXIuJj96hKdQe8Y6RTo2t6OJDTyhd1LznhgICH.jpg",
        "device_token":
            "cXOR5cDRQy6NKN32f0c_Ec:APA91bF0UdWH33mFol1v4F4JPbQEPPFcNvMWYUz5k_n-3cjJTSN5VmBJwWukCexDJvGpbu32BzBvxPJSbPY276ek_IvzMrw3EmSakSE2AT06lNGunZlTEkQU4Gy62YUmiGP2Jv9uPHUt",
        "followerCount": 0,
        "followingCount": 0,
        "followingMe": false,
        "followed": false,
        "user_image_url":
            "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/ZnFXIuJj96hKdQe8Y6RTo2t6OJDTyhd1LznhgICH.jpg",
        "postCount": 637
      },
      "challenges": []
    },
    {
      "id": 907,
      "user_id": 13,
      "body": "noma",
      "type": "image",
      "image":"https://bangapp.pro/BangAppBackend/storage/app/images/qEoNOF2JNitYXwfqh76Xu8J7bb9KwskWusvcKoBX.jpg",
      "challenge_img": null,
      "aspect_ratio": null,
      "cache_url": null,
      "thumbnail_url": null,
      "pinned": 1,
      "is_seen": 0,
      "public_id": null,
      "created_at": "1 day ago",
      "price": "1000.00",
      "post_views_count": 0,
      "width": 300,
      "height": 300,
      "isLikedA": false,
      "isLikedB": false,
      "isLiked": false,
      "like_count_A": 0,
      "like_count_B": 0,
      "favoriteCount": 0,
      "isFavorited": 0,
      "commentCount": 0,
      "user_image_url":
          "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/ZnFXIuJj96hKdQe8Y6RTo2t6OJDTyhd1LznhgICH.jpg",
      "user": {
        "id": 13,
        "name": "Ghost",
        "image":
            "profile_pictures/ZnFXIuJj96hKdQe8Y6RTo2t6OJDTyhd1LznhgICH.jpg",
        "device_token":
            "cXOR5cDRQy6NKN32f0c_Ec:APA91bF0UdWH33mFol1v4F4JPbQEPPFcNvMWYUz5k_n-3cjJTSN5VmBJwWukCexDJvGpbu32BzBvxPJSbPY276ek_IvzMrw3EmSakSE2AT06lNGunZlTEkQU4Gy62YUmiGP2Jv9uPHUt",
        "followerCount": 0,
        "followingCount": 0,
        "followingMe": false,
        "followed": false,
        "user_image_url":
            "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/ZnFXIuJj96hKdQe8Y6RTo2t6OJDTyhd1LznhgICH.jpg",
        "postCount": 637
      },
      "challenges": []
    },
    {
      "id": 906,
      "user_id": 13,
      "body": "noma",
      "type": "image",
      "image":"https://bangapp.pro/BangAppBackend/storage/app/images/92v2xl49tY0uTjZZMNgfLm7eouff3APlu4YbwPYn.jpg",
      "challenge_img": null,
      "aspect_ratio": null,
      "cache_url": null,
      "thumbnail_url": null,
      "pinned": 1,
      "is_seen": 0,
      "public_id": null,
      "created_at": "1 day ago",
      "price": "1000.00",
      "post_views_count": 0,
      "width": 300,
      "height": 300,
      "isLikedA": false,
      "isLikedB": false,
      "isLiked": false,
      "like_count_A": 0,
      "like_count_B": 0,
      "favoriteCount": 0,
      "isFavorited": 0,
      "commentCount": 0,
      "user_image_url":
          "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/ZnFXIuJj96hKdQe8Y6RTo2t6OJDTyhd1LznhgICH.jpg",
      "user": {
        "id": 13,
        "name": "Ghost",
        "image":
            "profile_pictures/ZnFXIuJj96hKdQe8Y6RTo2t6OJDTyhd1LznhgICH.jpg",
        "device_token":
            "cXOR5cDRQy6NKN32f0c_Ec:APA91bF0UdWH33mFol1v4F4JPbQEPPFcNvMWYUz5k_n-3cjJTSN5VmBJwWukCexDJvGpbu32BzBvxPJSbPY276ek_IvzMrw3EmSakSE2AT06lNGunZlTEkQU4Gy62YUmiGP2Jv9uPHUt",
        "followerCount": 0,
        "followingCount": 0,
        "followingMe": false,
        "followed": false,
        "user_image_url":
            "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/ZnFXIuJj96hKdQe8Y6RTo2t6OJDTyhd1LznhgICH.jpg",
        "postCount": 637
      },
      "challenges": [],
    },
  ];
List<Challenge> parseChallenges(List<dynamic> challengesData) {
  List<Challenge> challenges = [];
  for (var challengeData in challengesData) {
    Challenge challenge = challengeData;
    challenges.add(challenge);
  }
  return challenges;
}
  @override
  Widget build(BuildContext context) {
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    return Skeletonizer(
      enabled: _enabled,
      child: ListView.builder(
        key: const PageStorageKey<String>('page'),
        itemCount: postData.length + 1,
        itemBuilder: (context, index) {
          final post = postData[index];
          return PostItem2(
            post['id'],
            post['user_id'],
            post['user']['name'],
            post['image'],
            post['challenge_img'],
            post['body'],
            post['type'],
            post['width'],
            post['height'],
            post['like_count_A'],
            post['like_count_B'],
            post['commentCount'],
            post['user']['followerCount'],
            parseChallenges(post['challenges']),
            post['isLiked'],
            post['pinned'],
            post['isLikedA'],
            post['isLikedB'],
            post['created_at'],
            post['user_image_url'],
            post['cache_url'],
            post['thumbnail_url'],
            post['aspect_ratio'],
            post['price'],
            post['post_views_count'],
            myProvider: postsProvider,
          );
        },
      ),
    );
  }
}
