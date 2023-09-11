class Comment {
  final int id;
  final int userId;
  final int postId;
  final String body;

  Comment({
    required this.id,
    required this.userId,
    required this.postId,
    required this.body,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['user_id'],
      postId: json['post_id'],
      body: json['body'],
    );
  }
}
