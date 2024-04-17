class BangUpdate {
  final String filename;
  final String type;
  final String caption;
  final String userName;
  final String userImage;
  final int postId;
  bool isLiked;
  int likeCount;
  int commentCount;
  final String thumbnailUrl;
  final String cacheUrl;
  final String aspectRatio;

  BangUpdate({
    required this.filename,
    required this.type,
    required this.caption,
    required this.postId,
    required this.userName,
    required this.userImage,
    required this.likeCount,
    required this.isLiked,
    required this.commentCount,
    required this.thumbnailUrl,
    required this.cacheUrl,
    required this.aspectRatio,
  });

  factory BangUpdate.fromJson(Map<String, dynamic> json) {
    return BangUpdate(
       filename: json['filename'],
       type:json['type'],
       caption: json['caption'] ?? "",
       postId:json['id'],
       userName:json['user']['name'],
       userImage:json['user_image_url'],
       likeCount:json['bang_update_like_count'] != null &&
           json['bang_update_like_count'].isNotEmpty
           ? json['bang_update_like_count'][0]['like_count']
           : 0,
       isLiked: json['isLiked'],
       commentCount:json['bang_update_comments'] != null &&
           json['bang_update_comments'].isNotEmpty
           ? json['bang_update_comments'][0]['comment_count']
           : 0,
      thumbnailUrl: json['thumbnail_url'] ?? "",
      cacheUrl: json['cache_url'] ?? "",
      aspectRatio: json['aspect_ratio'] ??"",
    );


  }
}
