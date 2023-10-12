import 'package:bangapp/services/service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:timeago/timeago.dart' as timeago;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/urls.dart';

class Conversation {
  String? receiverName;
  int? receiverId;
  String? lastMessage;
  String? image;
  String? time;
  bool isActive;
  int unreadCount;
  int id;
  String messageType;

  Conversation({
    required this.id,
    required this.receiverId,
    required this.receiverName,
    required this.lastMessage,
    required this.image,
    required this.time,
    required this.isActive,
    required this.unreadCount,
    required this.messageType,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['conversation_id'],
      receiverName: json['receiver_name'],
      lastMessage: json['lastMessage'],
      image: json['image'],
      time: json['time'],
      isActive: json['isActive'],
      receiverId: json['receiver_id'],
      unreadCount: json['unreadCount'],
        messageType: "text",
    );
  }
}

class Message {
  final int id;
  final int senderId;
  final String message;
  final List<Participants>? participants;
  int isReady;
  Message({
    required this.id,
      required this.senderId,
      required this.message,
      this.participants,
      required this.isReady,
      });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['sender_id'],
      message: json['message'],
      participants: json['Participants'],
      isReady: json['is_read'],
    );
  }
}

class Participants {
  final String participant1_id;
  final String participant2_id;

  Participants(this.participant1_id, this.participant2_id);

  factory Participants.fromJson(Map<String, dynamic> json) {
    return Participants(json['participant1_id'], json['participant2_id']);
  }
}

class ChatProvider with ChangeNotifier {
// late final IO.Socket socket;

//   final String baseUrl = 'http://192.168.249.226/BangAppBackend/api';

  List<Conversation> _conversations = [];
  List<Message> _messages = [];

  List<Conversation> get conversations => _conversations;
  List<Message> get messages => _messages;

  bool _shouldRefresh = false;
  bool get shouldRefresh => _shouldRefresh;

  void setShouldRefresh(bool value) {
    _shouldRefresh = value;
    notifyListeners();
  }

  Future<void> getAllConversations(BuildContext context, int userId) async {
    print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/getAllConversations?user_id=$userId'));
      print(response);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _conversations =
            data.map((json) => Conversation.fromJson(json)).toList();
        notifyListeners();
        print(conversations);
      } else {
        throw Exception('Failed to load conversations');
      }
    } catch (error) {
      _showSnackbar('Error loading conversations: $error', context);
    }
  }

  Future<void> getMessages(
      BuildContext context, int user1Id, int user2Id) async {
    print("Message lenght is :: ${messages.length}");
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/getChatMessages?user1_id=$user2Id&user2_id=$user1Id'));
      print(response.body);

      if (response.statusCode == 200) {
        final List<Message> newMessages = [];
        final List<dynamic> data = json.decode(response.body);
        newMessages.addAll(data.map((json) => Message.fromJson(json)).toList());
        print("Message lenght is :: ${messages.length}");
        _messages.clear();
        _messages.addAll(newMessages);
        print("Message lenght is :: ${messages.length}");
        notifyListeners();
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (error) {
      _showSnackbar('Error loading messages: $error', context);
    }
  }

  Future<void> markMessageAsRead(int messageId) async {
    print("IM hereeeeeeeeeee");
    final url = Uri.parse('$baseUrl/markMessageAsRead');
    try {
      final response = await http.post(
        url,
        body: {
          'message_id': messageId.toString(),
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final thisMessaage =
            _messages.firstWhere((message) => message.id == messageId);
        thisMessaage.isReady = 1;
        notifyListeners();
      } else {
        // Handle errors here, e.g., log the error or show an error message
        print(
            'Failed to mark message as read. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error in marking read message: $e");
    }
  }

// chatProvider.sendMessage(context,  await getUserId(), widget.receiverId, messageText);

  void addMessage(newMessage) {
    _messages.insert(0, newMessage);
    notifyListeners();
  }

  Future<void> sendMessage(BuildContext context, int user1Id, int user2Id,
      String message, ChatProvider chatProvider, socket) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/sendMessage'), body: {
        'sender_id': user1Id.toString(),
        'user2_id': user2Id.toString(),
        'message': message,
      });

      if (response.statusCode == 200) {
        final newMessage = Message.fromJson(jsonDecode(response.body));
        final serv = new Service();
        final data = jsonDecode(response.body);
        final createdAt = DateTime.parse(data['created_at']);
        final timeAgo = timeago.format(createdAt);
        final rawMessage = {
          'conversation_id': data['conversation_id'].toString(),
          'sender_id': user1Id.toString(),
          'user2_id': user2Id.toString(),
          'message': data['message'],
          'time': timeAgo,
        };
        print(rawMessage);
        socket.emit('updateLastMessageInConversation', rawMessage);

        serv.sendUserNotification(
            userId,
            "JUmaaa",
            "This is a test notification",
            prefs.getInt('user_id').toString(),
            'like', 0);

        // chatProvider._messages.insert(0, newMessage);
        notifyListeners();
        // _showSnackbar('Message sent successfully', context);
      } else {
        throw Exception('Failed to send message');
      }
    } catch (error) {
      _showSnackbar('Error sending message: $error', context);
    }
  }

  Future<void> startConversation(
      BuildContext context, int userId, int recipientId) async {
    print("Executing startConversation.........................");
    print("$userId, $recipientId");

    final body = {
      'user_id': userId.toString(),
      'recipient_id': recipientId.toString(),
    };
    final response = await http.post(
        Uri.parse('$baseUrl/startNewChat'),
        body: {
          'user_id': userId.toString(),
          'recipient_id': recipientId.toString(),
        });
    print(body);
    print(Uri.parse('$baseUrl/startNewChat'));
    print(response.body);

    if (response.statusCode == 201) {
      final dynamic data = json.decode(response.body);
      _conversations.add(Conversation.fromJson(data));
      notifyListeners();
    } else {
      throw Exception('Failed to start conversation');
    }
  }

  void _showSnackbar(String message, context) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateLastMessageInConverstion(lastMessage) {
    print("updateLastMessageInConverstion");
    print(lastMessage);
    conversations.forEach((element) {
      print(element.id);
    });

    final conversation = conversations.firstWhere(
        (conversation) =>
            conversation.id == int.parse(lastMessage['conversation_id']),
        orElse: () => Conversation(
              id: 0,
              receiverName: "lastMessage['receiver_name']",
              lastMessage: "lastMessage['message']",
              image: "assets/images/app_iconw.jpg",
              time: "lastMessage['time']",
              isActive: false,
              receiverId: 11,
              unreadCount: 11,
               messageType: '',
            ));

    if (conversation.id != 0) {
      print(conversation);
      conversation.lastMessage = lastMessage['message'];
      conversation.time = lastMessage['time'];
      conversation.unreadCount++;

      // Move the conversation to the top of the list
      conversations.remove(conversation);
      conversations.insert(0, conversation);

      notifyListeners();
    } else {
      print(
          'Conversation not found with id: ${lastMessage['conversation_id']}');
    }
}
}



