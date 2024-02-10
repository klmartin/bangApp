
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
  final String userName;
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
    required this.userName,
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
      userName: json['user']['name'],
      message: json['message'],
      type: json['type'],
      referenceId: json['reference_id'],
      postId: json['post_id'],
      userImage: json['user']['user_image_url'],
      isRead: json['is_read'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
