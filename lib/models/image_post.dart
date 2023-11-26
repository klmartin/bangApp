
class ImagePost {
   String? imageUrl;
   String? name;
  String? caption;
  String? challengeImgUrl;
  int? imgWidth;
  int? imgHeight;
  int? postId;
  int? commentCount;
  int? userId;
  bool? isLiked;
  int? likeCount;
  String? type;
  int? followerCount;
  String? createdAt;
  String? userImage;
  int? pinned;

  ImagePost(
      {this.name,
      this.caption,
      this.imageUrl,
      this.challengeImgUrl,
      this.imgWidth,
      this.imgHeight,
      this.postId,
      this.commentCount,
      this.userId,
      this.isLiked,
      this.likeCount,
      this.type,
      this.followerCount,
      this.createdAt,
      this.userImage,
      this.pinned});

  factory ImagePost.fromJson(Map<String, dynamic> json) {
    return ImagePost(
      name: json['user']['name'],
        caption:json['body'] ?? "",
        imageUrl:json['image'],
        challengeImgUrl: json['challenge_img']??"",
        imgWidth:json['width'],
        imgHeight:json['height'],
        postId:json['id'],
        commentCount:json['commentCount'],
        userId:json['user']['id'],
        isLiked:json['isLiked'],
        likeCount:json['like_count_A'],
        type:json['type'],
        followerCount:json['followerCount'],
        createdAt:json['created_at'],
        userImage:json['user_image_url'],
        pinned: json['pinned']
    );


  }
}
