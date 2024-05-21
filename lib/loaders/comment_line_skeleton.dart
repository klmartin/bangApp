import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:bangapp/models/comment.dart';

List<dynamic> commentsData =  [
  {
    "id": 212,
    "user_id": 6,
    "post_id": 911,
    "body": "kajala",
    "created_at": "1 hour ago",
    "updated_at": "2024-03-23T11:53:30.000000Z",
    "favoriteCount": 0,
    "isFavorited": 0,
    "user_image_url": "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
    "replies_count": 0,
    "comment_replies": [],
    "user": {
      "id": 6,
      "name": "martinkb",
      "image": "profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
      "followerCount": 0,
      "followingCount": 0,
      "followingMe": false,
      "followed": false,
      "user_image_url": "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
      "postCount": 33
    }
  },
  {
    "id": 214,
    "user_id": 6,
    "post_id": 911,
    "body": "nice",
    "created_at": "34 minutes ago",
    "updated_at": "2024-03-23T12:26:06.000000Z",
    "favoriteCount": 0,
    "isFavorited": 0,
    "user_image_url": "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
    "replies_count": 0,
    "comment_replies": [],
    "user": {
      "id": 6,
      "name": "martinkb",
      "image": "profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
      "followerCount": 0,
      "followingCount": 0,
      "followingMe": false,
      "followed": false,
      "user_image_url": "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
      "postCount": 33
    }
  },
  {
    "id": 215,
    "user_id": 6,
    "post_id": 911,
    "body": "comment",
    "created_at": "26 minutes ago",
    "updated_at": "2024-03-23T12:33:54.000000Z",
    "favoriteCount": 0,
    "isFavorited": 0,
    "user_image_url": "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
    "replies_count": 0,
    "comment_replies": [],
    "user": {
      "id": 6,
      "name": "martinkb",
      "image": "profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
      "followerCount": 0,
      "followingCount": 0,
      "followingMe": false,
      "followed": false,
      "user_image_url": "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
      "postCount": 33
    }
  },
  {
    "id": 216,
    "user_id": 6,
    "post_id": 911,
    "body": "goodd",
    "created_at": "24 minutes ago",
    "updated_at": "2024-03-23T12:35:40.000000Z",
    "favoriteCount": 0,
    "isFavorited": 0,
    "user_image_url": "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
    "replies_count": 0,
    "comment_replies": [],
    "user": {
      "id": 6,
      "name": "martinkb",
      "image": "profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
      "followerCount": 0,
      "followingCount": 0,
      "followingMe": false,
      "followed": false,
      "user_image_url": "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
      "postCount": 33
    }
  },
  {
    "id": 217,
    "user_id": 6,
    "post_id": 911,
    "body": "godj",
    "created_at": "24 minutes ago",
    "updated_at": "2024-03-23T12:36:08.000000Z",
    "favoriteCount": 0,
    "isFavorited": 0,
    "user_image_url": "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
    "replies_count": 0,
    "comment_replies": [],
    "user": {
      "id": 6,
      "name": "martinkb",
      "image": "profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
      "followerCount": 0,
      "followingCount": 0,
      "followingMe": false,
      "followed": false,
      "user_image_url": "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
      "postCount": 33
    }
  },
  {
    "id": 218,
    "user_id": 6,
    "post_id": 911,
    "body": "nice",
    "created_at": "14 minutes ago",
    "updated_at": "2024-03-23T12:46:09.000000Z",
    "favoriteCount": 0,
    "isFavorited": 0,
    "user_image_url": "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
    "replies_count": 0,
    "comment_replies": [],
    "user": {
      "id": 6,
      "name": "martinkb",
      "image": "profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
      "followerCount": 0,
      "followingCount": 0,
      "followingMe": false,
      "followed": false,
      "user_image_url": "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
      "postCount": 33
    }
  },
  {
    "id": 219,
    "user_id": 6,
    "post_id": 911,
    "body": "gcvhg",
    "created_at": "2 minutes ago",
    "updated_at": "2024-03-23T12:57:41.000000Z",
    "favoriteCount": 0,
    "isFavorited": 0,
    "user_image_url": "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
    "replies_count": 0,
    "comment_replies": [],
    "user": {
      "id": 6,
      "name": "martinkb",
      "image": "profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
      "followerCount": 0,
      "followingCount": 0,
      "followingMe": false,
      "followed": false,
      "user_image_url": "https://bangapp.pro/BangAppBackend/storage/app/profile_pictures/LK3KegKj5BPHD8xokrE03Srf5ZUrLPIUp3mq4F0X.jpg",
      "postCount": 33
    }
  }
];


final comment = commentsData.map((commentData) => Comment.fromJson(commentData)).toList();

class CommentLineSkeleton extends StatefulWidget {
  const CommentLineSkeleton();

  @override
  State<CommentLineSkeleton> createState() => _CommentLineSkeletonState();
}

class _CommentLineSkeletonState extends State<CommentLineSkeleton> {
  bool _enabled = true;

  Widget build(BuildContext context) {
    print(comment.length);
    print('comment length');
    return  Skeletonizer(
      enabled: _enabled,
        child:  ListView.builder(
        itemCount: comment.length,
        itemBuilder: (context, index) {
           Padding(
              padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
        child: ExpansionTile(
        key: Key('expansion_${comment.last.id}'),
        leading: GestureDetector(
          onTap: () async {
            print("Comment Clicked");
          },
          child: Container(
            height: 50.0,
            width: 50.0,
            decoration: new BoxDecoration(
              color: Colors.blue,
              borderRadius: new BorderRadius.all(Radius.circular(50)),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: CommentBox.commentImageParser(
                imageURLorPath: comment.first.userImageUrl,
              ),
            ),
          ),
        ),
        title: Text(
          comment.first.commentUser!.name ?? "",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(comment.first.body ?? "",
                style: TextStyle(fontWeight: FontWeight.w500)),
            SizedBox(height: 5),
            GestureDetector(

              child: Text("Reply"),
            ),
            Center(
              child: comment.first.repliesCount! > 0
                  ? Text('${comment.first.repliesCount!} Replies')
                  : Container(),
            )
          ],
        ),
        trailing: Text(comment.first.createdAt ?? "", style: TextStyle(fontSize: 10)),
        children: [
          // List of replies goes here
          for (var reply in comment.first.commentReplies!)
            ListTile(
              leading: GestureDetector(
                onTap: () async {},
                child: Container(
                  height: 30.0,
                  width: 30.0,
                  decoration: new BoxDecoration(
                    color: Colors.blue,
                    borderRadius: new BorderRadius.all(Radius.circular(30)),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: CommentBox.commentImageParser(
                      imageURLorPath: reply.userImageUrl,
                    ),
                  ),
                ),
              ),
              title: Text(
                reply.replyUser!.name ?? "",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(reply.body ?? ""),
              trailing: Column(children: [
                Text(reply.createdAt!, style: TextStyle(fontSize: 7)),
              ]),
            ),
        ],
      ));
           return null;

        })
        );
  }
}
