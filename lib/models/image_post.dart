
class ImagePost {
  final String imageUrl;
  final String name;
  String caption;
  String challengeImgUrl;
  int imgWidth;
  int imgHeight;
  int postId;
  int commentCount;
  int userId;
  bool isLiked;
  int likeCount;
  String type;
  int followerCount;
  String createdAt;
  String userImage;
  int pinned;
  ImagePost(this.name,this.caption,this.imageUrl,this.challengeImgUrl, this.imgWidth, this.imgHeight, this.postId, this.commentCount, this.userId,this.isLiked,this.likeCount,this.type,this.followerCount,this.createdAt,this.userImage,this.pinned);
}
