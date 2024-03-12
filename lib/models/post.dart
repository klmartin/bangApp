class Post {
  final int postId;
  final int userId;
  final String name;
  final String type;
  final String image;
  String? challengeImg;
  String? video;
  final String caption;
  final int width;
  final int height;
  int likeCountA;
  int likeCountB;
  int commentCount;
  final int followerCount;
  var isLiked ;
  int isPinned;
  final List<Challenge> challenges;
  var createdAt;
  var isLikedA;
  var  isLikedB;
  final String userImage;
  String? cacheUrl;
  String? thumbnailUrl;
  String? aspectRatio;
  String? price;


  Post({
    required this.postId,
    required this.userId,
    required this.name,
    required this.image,
    required this.challengeImg,
    required this.caption,
    required this.type,
    required this.width,
    required this.height,
    required this.likeCountA,
    required this.likeCountB,
    required this.commentCount,
    required this.followerCount,
    required this.isLiked,
    required this.isPinned,
    required this.challenges, // Add the challenges parameter to the constructor
    required this.isLikedA,
    required this.isLikedB,
    required this.createdAt,
    required this.userImage,
    required this.cacheUrl,
    required this.thumbnailUrl,
    required this.aspectRatio,
    required this.price,
  });
}

class Challenge {
  final int id;
  final int postId;
  final int userId;
  final String challengeImg;
  final String body;
  final String type;
  final int confirmed;

  Challenge( {
    required this.id,
    required this.postId,
    required this.userId,
    required this.challengeImg,
    required this.body,
    required this.type,
    required this.confirmed,
  });
}

