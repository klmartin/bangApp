class BangUpdate {
  int id;
  String caption;
  String filename;
  String type;
  String createdAt;
  final List<BangUpdateLike> bangUpdateLikes; // You might need to define a separate model for this if necessary

  BangUpdate({
    required this.id,
    required this.caption,
    required this.filename,
    required this.type,
    required this.createdAt,
    required this.bangUpdateLikes,
  });

}

class BangUpdateLike {
  int postId;
  int likeCount;

  BangUpdateLike({
    required this.postId,
    required this.likeCount,
  });
}