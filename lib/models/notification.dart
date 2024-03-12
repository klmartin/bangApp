
class NotificationModel {
  final List<NotificationItem> notifications;

  NotificationModel({required this.notifications});

  factory NotificationModel.fromJson(List<dynamic> json) {
    // Extract the 'notifications' field as a dynamic
    final dynamic notificationData = json;

    // Check if it's a List<dynamic> or a single Map<String, dynamic>
    final List<NotificationItem> notifications = (notificationData is List<dynamic>)
        ? notificationData
        .map((notification) => NotificationItem.fromJson(notification))
        .toList()
        : [NotificationItem.fromJson(notificationData)];

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
  final String postUrl;
  final String thumbnailUrl;
  final String postType;
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
    required this.postUrl,
    required this.thumbnailUrl,
    required this.postType,
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
      postUrl: json['post_image_url'],
      thumbnailUrl: json['post_thumbnail_url'] ?? "",
      postType: json['post_type'] ?? "",
    );
  }
}
