import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bangapp/screens/Chat/calls_chat.dart';
import 'package:bangapp/screens/Chat/chat_model.dart';
import 'package:bangapp/screens/Chat/new_message_chat.dart';
// import 'group_chat.dart';
import 'package:bangapp/models/chat_message.dart';
import 'package:bangapp/services/service.dart';


List<String> docList = [];


class ChatHome extends StatefulWidget {
  static const String id = 'chat_home';
  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  //initialising firestore

  late String messageText;

  @override
  void initState() {
    super.initState();
    // docCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(CupertinoIcons.back),
          color: Colors.black,
        ),
        elevation: 0,
        title: Text(
          'Chats',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Metropolis',
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CallsChat(),
                ),
              );
            },
            icon: Icon(
              CupertinoIcons.video_camera,
              size: 40,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewMessageChat(),
                ),
              );
            },
            icon: Icon(
              CupertinoIcons.paperplane,
              size: 28,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.stretch,
        //   children: <Widget>[
        //     Padding(
        //       padding: const EdgeInsets.symmetric(vertical: 16.0),
        //       child: SearchBox(),
        //     ),
        child: UsersStream(),
        //   ],
        // ),
      ),
    );
  }
}

class UserBubble extends StatefulWidget {
  final int id;
  final bool isMe;
  final int senderId;
  final int receiverId;
  final String message;
  final String createdAt;
  final String updatedAt;
  final UserProfile sender;
  final UserProfile receiver;

  UserBubble({
    required this.id,
    required this.isMe,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.sender,
    required this.receiver,
  });

  @override
  State<UserBubble> createState() => _UserBubbleState();
}

class _UserBubbleState extends State<UserBubble> {
  String truncateText(String text, int maxLength) {
    if (text.split(' ').length > maxLength) {
      List<String> words = text.split(' ');
      return words.sublist(0, maxLength).join(' ') + '...';
    }
    return text;
  }
  @override
  Widget build(BuildContext context) {
    if (!widget.isMe) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            print('tapped');
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PmScreen(
                    profileUrl: widget.sender.image,
                    name: widget.sender.name,
                    selectedUser: widget.sender.id.toString(),
                  ),
                ),
              );
              // Handle onTap event if needed
            });
          },
          child: Container(
            height: 70,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          radius: 32,
                          backgroundImage: CachedNetworkImageProvider(widget.sender.image),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.sender.name,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Metropolis'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  truncateText(widget.message, 5),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'Metropolis',
                                  ),
                                ),

                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FaIcon(FontAwesomeIcons.comment),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}


class UsersStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChatMessage>>(
      future: Service().getMessage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlue,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No messages'),
          );
        }
        final List<ChatMessage> messages = snapshot.data!;

        return Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return UserBubble(message: message.message, id: message.id, isMe: message.isMe, senderId: message.senderId, receiverId: message.receiverId, createdAt: message.createdAt, updatedAt: message.updatedAt, sender: message.sender, receiver: message.receiver,);
            },
          ),
        );
      },
    );
  }
}

class SendersStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChatMessage>>(
      future: Service().getMessage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No messages'),
          );
        }

        final List<ChatMessage> messages = snapshot.data!;

        return Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              // Here, you should create instances of UserBubble widget using the message details.
              // You can pass in message attributes like id, senderId, receiverId, message, etc.,
              // along with their corresponding sender and receiver user profiles.
              return UserBubble(
                id: message.id,
                senderId: message.senderId,
                receiverId: message.receiverId,
                message: message.message,
                createdAt: message.createdAt,
                updatedAt: message.updatedAt,
                sender: message.sender,
                receiver: message.receiver,
                isMe: message.isMe,
              );
            },
          ),
        );
      },
    );
  }
}

