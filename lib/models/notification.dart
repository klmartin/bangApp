class NotificationModel {
  final List<NotificationItem> notifications;
  NotificationModel({required this.notifications});
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> notificationList = json['notifications'];
    List<NotificationItem> notifications = notificationList
        .map((notification) => NotificationItem.fromJson(notification))
        .toList();

    return NotificationModel(notifications: notifications);
  }
}

class NotificationItem {
  final int id;
  final int userId;
  final String message;
  final String type;
  final int referenceId;
  final int postId;
  final String userImage;
  final int isRead;
  final String createdAt;
  final String updatedAt;

  NotificationItem({
    required this.id,
    required this.userId,
    required this.message,
    required this.type,
    required this.referenceId,
    required this.postId,
    required this.userImage,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      userId: json['user_id'],
      message: json['message'],
      type: json['type'],
      referenceId: json['reference_id'],
      postId: json['post_id'],
      userImage: json['user_image'],
      isRead: json['is_read'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
