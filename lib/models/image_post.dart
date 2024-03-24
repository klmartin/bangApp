class ImagePost {
  String? imageUrl;
  String? name;
  String? caption;
  String? challengeImgUrl;
  int? imgWidth;
  int? imgHeight;
  int? postId;
  int commentCount;
  int? userId;
  bool isLikedA;
  bool isLikedB;
  int likeCountA;
  int likeCountB;
  String? type;
  int? followerCount;
  String? createdAt;
  String? userImage;
  int? pinned;
  String? cacheUrl;
  String? thumbnailUrl;
  String? aspectRatio;
  int? price;
  int postViews;

  ImagePost({
    this.name,
    this.caption,
    this.imageUrl,
    this.challengeImgUrl,
    this.imgWidth,
    this.imgHeight,
    this.postId,
    required this.commentCount,
    this.userId,
    required this.isLikedA,
    required this.isLikedB,
    required this.likeCountA,
    required this.likeCountB,
    this.type,
    this.followerCount,
    this.createdAt,
    this.userImage,
    this.pinned,
    this.cacheUrl,
    this.thumbnailUrl,
    this.aspectRatio,
    this.price,
    required this.postViews,
  });

  factory ImagePost.fromJson(Map<String, dynamic> json) {
    return ImagePost(
      name: json['user']['name'],
      caption: json['body'] ?? "",
      imageUrl: json['image'],
      challengeImgUrl: json['challenge_img'] ?? "",
      imgWidth: json['width'],
      imgHeight: json['height'],
      postId: json['id'],
      commentCount: json['commentCount'],
      userId: json['user']['id'],
      isLikedA: json['isLikedA'],
      isLikedB: json['isLikedB'],
      likeCountA: json['like_count_A'],
      likeCountB: json['like_count_B'],
      type: json['type'],
      followerCount: json['user']['followerCount'],
      createdAt: json['created_at'],
      userImage: json['user_image_url'],
      pinned: json['pinned'],
      cacheUrl: json['cache_url'],
      thumbnailUrl: json['thumbnail_url'],
      aspectRatio: json['aspect_ratio'],
      postViews: json['post_views_count'] ?? 0,
    );
  }
}
