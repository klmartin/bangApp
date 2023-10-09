import 'dart:convert';

import 'package:bangapp/message/constants.dart';
import 'package:bangapp/message/models/ChatMessage.dart';
import 'package:bangapp/message/screens/messages/components/message.dart'
    as MSG;
import 'package:bangapp/providers/chat_provider.dart';
import 'package:bangapp/screens/Profile/profile_upload.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';


import 'components/body.dart';

class MessagesScreen extends StatefulWidget {
  int receiverId;
  String receiverUsername;

  MessagesScreen(this.receiverId, this.receiverUsername);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  late final IO.Socket socket; // Declare socket as an instance variable

  ScrollController _scrollController = new ScrollController();
  bool _firstAutoscrollExecuted = false;
  bool _shouldAutoscroll = false;

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    return userId ?? 0; // Handle null or non-integer values
  }

  @override
  void initState() {
    super.initState();
    _startAConversation(); // Load chat messages when the screen initializes
    _getThisUsersMessages();
    connect();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void _scrollListener() {
    _firstAutoscrollExecuted = true;

    if (_scrollController.hasClients &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      _shouldAutoscroll = true;
    } else {
      _shouldAutoscroll = false;
    }
  }
// http://137.184.33.100:3000/
  void connect() {
    socket = IO.io('ws://137.184.33.100:3000/', <String, dynamic>{
      "transports": ['websocket'],
      "autoconect": false,
    });
    socket.connect();
    socket.onConnect((_) {
      print("Connected to frontend");
    });

    socket.on('message', (message) async {
      print("Message received from backend:");
      final participant1ID = message['participant1_id'];
      final participant2ID = message['participant2_id'];

      final userId = await getUserId();
      final receiverId = widget.receiverId;
      print(userId);
      print(receiverId);
      print(participant1ID);
      print(participant2ID);

      // Check if the message is intended for the current user
      if ((participant1ID == userId && participant2ID == receiverId) ||
          (participant2ID == userId && participant1ID == receiverId)) {
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);

        print(message);
        final newMessage = Message.fromJson(message);
        print(newMessage);
        chatProvider.addMessage(newMessage);
        print("Message is: $message");
      } else {
        print("Discarding message as it is not intended for the current user.");
      }
    });
  }

  Future<void> _sendMessageToSocket(Map<String, dynamic> rawMessage) async {
    if (socket.connected) {
      try {
        final participants = {
          "participant1_id": await getUserId(),
          "participant2_id": widget.receiverId,
        };
        socket.emit('join', participants);
        rawMessage['participant1_id'] = await getUserId();
        rawMessage['participant2_id'] = widget.receiverId;

        rawMessage['participants'] = participants;
        rawMessage['is_read'] = 0;
        socket.emit('chat_message', rawMessage);
        print("Message sent via WebSocket");


      } catch (e) {
        print("Error sending message via WebSocket: $e");
      }
    } else {
      print("WebSocket is not connected. Message not sent.");
    }
  }

  void _startAConversation() async {
    print("Executing this.........................");
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.startConversation(
        context, await getUserId(), widget.receiverId);
  }

  void _getThisUsersMessages() async {
    print("Executing this.........................");
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.getMessages(context, await getUserId(), widget.receiverId);

    setState(() {
      if (_scrollController.hasClients && _shouldAutoscroll) {
        _scrollToBottom();
      }

      if (!_firstAutoscrollExecuted && _scrollController.hasClients) {
        _scrollToBottom();
      }
    });
  }

  void _sendMessage(String messageText) async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.sendMessage(context, await getUserId(), widget.receiverId,
        messageText, chatProvider, socket);
    final rawMessage = {
      "id": 22222,
      "sender_id": await getUserId(),
      "message": messageText,
    };
    _sendMessageToSocket(rawMessage);
    setState((  ) {
      if (_scrollController.hasClients && _shouldAutoscroll) {
        _scrollToBottom();
      }

      if (!_firstAutoscrollExecuted && _scrollController.hasClients) {
        _scrollToBottom();
      }
    });
  }

  void markMessageAsReadHere(message) async{
    if (message.isReady == 0  && message.senderId != await getUserId()) {
      print("Marking message as read");
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider.markMessageAsRead(message.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  final messages = chatProvider.messages;
                  return ListView.builder(
                      controller:
                          _scrollController, // Attach the controller here
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final userIdFuture =
                            getUserId(); // Get the user ID as a Future
                        markMessageAsReadHere(messages[index]);
                        return FutureBuilder<int>(
                          // Use FutureBuilder to handle the asynchronous operation
                          future: userIdFuture,
                          builder: (context, userIdSnapshot) {
                           if (userIdSnapshot.hasError) {
                              // Handle errors if the user ID future fails
                              return Text('Error: ${userIdSnapshot.error}');
                            } else {
                              // The user ID future has completed successfully
                              final userId = userIdSnapshot.data;
                              final isSender = message.senderId == userId;
                              return MSG.Message(
                                message: ChatMessage(
                                  text: messages[index].message,
                                  messageType: ChatMessageType.text,
                                  messageStatus:   message.isReady == 0 ? MessageStatus.not_view : MessageStatus.viewed,
                                  isSender: isSender,
                                  id: messages[index].id,
                                  isReady: messages[index].isReady,
                                ),
                              );
                            }
                          },
                        );
                      });
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding / 2,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 32,
                  color: const Color(0xFF087949).withOpacity(0.08),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _handleAttachmentPressed,
                    child: Icon(
                      Icons.attach_file,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.64),
                    ),
                  ),
                  const SizedBox(width: kDefaultPadding / 4),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: TextInputField(context),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Row TextInputField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: "Type message",
              border: InputBorder.none,
            ),
            onSubmitted: (_) {
              _sendMessage(_textEditingController.text);
              _textEditingController.clear();
            }, // Submit action
          ),
        ),
        GestureDetector(
          onTap: () {
            _sendMessage(_textEditingController.text);
            _textEditingController.clear();
          }, // Send message on button tap
          child: Icon(
            Icons.send_outlined,
            color:
                Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.64),
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                Provider.of<ChatProvider>(context, listen: false).setShouldRefresh(true);

              },
              child: Icon(Icons.arrow_back, color: Colors.white, size: 33),
            ),
          ),
          const CircleAvatar(
            backgroundImage: AssetImage("assets/images/user_2.png"),
          ),
          const SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.receiverUsername.toString(),
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Active 3m ago",
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.local_phone),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () {},
        ),
        const SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }


  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
                TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleVideoSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Video'),
                ),
              ),
            //   TextButton(
            //     onPressed: () {
            //       Navigator.pop(context);
            //       _handleFileSelection();
            //     },
            //     child: const Align(
            //       alignment: AlignmentDirectional.centerStart,
            //       child: Text('File'),
            //     ),
            //   ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
    //   final message = types.FileMessage(
    //     author: _user,
    //     createdAt: DateTime.now().millisecondsSinceEpoch,
    //     id: const Uuid().v4(),
    //     mimeType: lookupMimeType(result.files.single.path!),
    //     name: result.files.single.name,
    //     size: result.files.single.size,
    //     uri: result.files.single.path!,
    //   );

    //   _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final message = ChatMessage(id: 000, text: image.toString(), messageType: ChatMessageType.image, messageStatus: MessageStatus.not_view, isSender: true, isReady: 0);
      final mess = Message(id: 000, senderId: 12, message: image.toString(), isReady: 0);

    //   final message = types.ImageMessage(
    //     author: _user,
    //     createdAt: DateTime.now().millisecondsSinceEpoch,
    //     height: image.height.toDouble(),
    //     id: const Uuid().v4(),
    //     name: result.name,
    //     size: bytes.length,
    //     uri: result.path,
    //     width: image.width.toDouble(),
    //   );

    //   _addMessage(message);
    }
  }

  void _handleVideoSelection() async {
    final result = await ImagePicker().pickVideo (
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

    //   final message = types.ImageMessage(
    //     author: _user,
    //     createdAt: DateTime.now().millisecondsSinceEpoch,
    //     height: image.height.toDouble(),
    //     id: const Uuid().v4(),
    //     name: result.name,
    //     size: bytes.length,
    //     uri: result.path,
    //     width: image.width.toDouble(),
    //   );

    //   _addMessage(message);
    }
  }

}
