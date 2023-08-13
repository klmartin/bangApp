class ChatMessage {
  final int id;
  final int senderId;
  final int receiverId;
  final String message;
  final String createdAt;
  final String updatedAt;
  final bool isMe;
  final UserProfile sender;
  final UserProfile receiver;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.isMe,
    required this.sender,
    required this.receiver,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      message: json['message'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      isMe: json['isMe'] ?? false,
      sender: UserProfile.fromJson(json['sender']),
      receiver: UserProfile.fromJson(json['receiver']),
    );
  }
}

class UserProfile {
  final int id;
  final String name;
  final String username;
  final String image;

  UserProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.image,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      username: json['username'] ?? '',
      image: json['image'],
    );
  }
}
