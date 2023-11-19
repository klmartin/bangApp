import 'package:bangapp/services/service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bangapp/widgets/bloc/file_handler_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../models/chat_message.dart';
import '../../models/userprovider.dart';

bool isOpen = false;

InputDecoration kMessageTextFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 20.0,
    ),
    prefixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.emoji_emotions_outlined)),
    suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt)),
    hintText: 'Type a message',
    hintStyle: TextStyle(
      height: 1.5,
    ),
    border: InputBorder.none);

const kMessageContainerDecoration = BoxDecoration(
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.black,
      blurRadius: 0.7,
    ),
  ],
  borderRadius: BorderRadius.only(
      topLeft: Radius.circular(32),
      bottomRight: Radius.circular(32),
      bottomLeft: Radius.circular(32)),
);

class PmScreen extends StatefulWidget {
  static const String id = 'chat_pm';
  final String selectedUser;
  final String profileUrl;
  final String name;

  PmScreen(
      {
        required this.selectedUser,
        required this.name,
        required this.profileUrl
      });
  @override
  _PmScreenState createState() => _PmScreenState();
}

class _PmScreenState extends State<PmScreen> {
  final messageTextController = TextEditingController();
  late String messageText;
  late IO.Socket socket;
  @override

  void initState() {
    print('nimeanza');
    super.initState();
    final channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.180.229:6001'),
    );

    channel.stream.listen((event) {
      // Handle the received event data here
      print('Received event: $event');
    });
    socket = IO.io('http://192.168.180.229/social-backend-laravel/socket', <String, dynamic>{
      'transports': ['websocket'],
    });

    // Listen for events
    socket.on('newMessage', (data) {
      // Handle the new message event
      print('New message received here: $data');
    });
    socket.on('connect', (_) {
      print('WebSocket connected');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(CupertinoIcons.back),
          color: Colors.black,
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: CachedNetworkImageProvider(widget.profileUrl),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                widget.name,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.videocam,
                color: Colors.black,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.phone,
                color: Colors.black,
              ),
            ),
            Positioned(
              left: -130,
              top: 0,
              child: DropdownButton2(
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ), items: [],
                // other parameters
              ),
            ),

          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(
              selectedUser: widget.selectedUser,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                // decoration: ,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: kMessageContainerDecoration,
                        child: TextField(
                          controller: messageTextController,
                          onChanged: (value) {
                            messageText = value;
                            //Do something with the user input.
                          },
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Service().sendMessage(widget.selectedUser,messageText);
                        messageTextController.clear();
                        setState(() {
                          MessageBubble(text: messageText, sender: widget.selectedUser, isMe: true);
                        });
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.purple,
                        radius: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  void onMenuStateChange(open) {
    setState(() {
      isOpen = open;
    });
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  MessageBubble(
      {required this.text, required this.sender, required this.isMe});
  @override
  Widget build(BuildContext context) {
    if(!isMe) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(minWidth: 0, maxWidth: 200),
              decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          topLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0)
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple,
                          Colors.deepPurple,
                          Colors.blueAccent ],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                    ),
                child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                child: RichText(
                  overflow: TextOverflow.clip,
                  strutStyle: StrutStyle(fontSize: 12.0),
                  text: TextSpan(
                    style:TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            // fontWeight: FontWeight.w500,
                            fontFamily: 'Metropolis'),
                    text: text == null ? '' : text,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                sender,
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ),
            Container(
              constraints: BoxConstraints(minWidth: 0, maxWidth: 200),
              // elevation: 5.0,
              decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink, Colors.redAccent, Colors.orange],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0)),
                    ),

              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                child: Text(
                  text == null ? '' : text,
                  style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'Metropolis',
                        ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}


class MessageStream extends StatefulWidget {
  final selectedUser;

  MessageStream({required this.selectedUser});

  @override
  _MessageStreamState createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {
  late IO.Socket socket;
  @override
  void initState() {
    super.initState();
    socket = IO.io('http://192.168.180.229/social-backend-laravel:6001', <String, dynamic>{
      'transports': ['websocket'],
    });

    // Listen for events
    socket.on('newMessage', (data) {
      // Handle the new message event
      print('New message received: $data');
    });
    socket.on('connect', (_) {
      print('WebSocket connected');
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChatMessage>>(
      future: Service().getMessages(widget.selectedUser),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlue,
            ),
          );
        }
        final messages = snapshot.data!;
        final currentUserID = Provider.of<UserProvider>(context).myUser.id;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final isMe = currentUserID.toString() == message.receiver.id.toString();
          final messageBubble = MessageBubble(
            text: message.message,
            sender: message.sender.name,
            isMe: isMe,
          );
          messageBubbles.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            reverse: false,
            children: messageBubbles,
          ),
        );
      },
    );
  }
}


class MenuItem extends StatefulWidget {
  final String value;
  final String text;
  final Widget widget;
  const MenuItem({
    Key? key,
    required this.value,
    required this.widget,
    required this.text,
  }) : super(key: key);

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  @override
  Widget build(BuildContext context) {
    return widget.widget ?? Container();
  }
}

class Block extends StatefulWidget {
  const Block({required Key key}) : super(key: key);

  @override
  State<Block> createState() => _BlockState();
}

class _BlockState extends State<Block> {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Block',
    );
  }
}

class Report extends StatefulWidget {
  const Report({required Key key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Report',
    );
  }
}
