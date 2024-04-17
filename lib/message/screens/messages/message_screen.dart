import 'dart:io';

import 'package:bangapp/message/constants.dart';
import 'package:bangapp/message/models/ChatMessage.dart';
import 'package:bangapp/message/screens/messages/components/message.dart'
    as MSG;
import 'package:bangapp/providers/user_provider.dart';
import 'package:bangapp/providers/chat_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:video_player/video_player.dart';
import '../../../providers/message_payment_provider.dart';
import '../../../providers/payment_provider.dart';
import '../../../providers/subscription_payment_provider.dart';

class MessagesScreen extends StatefulWidget {
  int receiverId;
  String receiverUsername;
  String userImage;
  bool? privacySwitchValue;
  int conversationId;
  String? price;

  MessagesScreen(this.receiverId, this.receiverUsername, this.userImage,
      this.privacySwitchValue, this.conversationId, this.price);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  late final IO.Socket socket; // Declare socket as an instance variable

  ScrollController _scrollController = new ScrollController();
  bool _firstAutoscrollExecuted = false;
  bool _shouldAutoscroll = false;
  late PaymentProvider paymentProvider;
  late ChatProvider chatProvider;
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
    _getThisUsersMessages();
    connect();
    paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _scrollController.addListener(_scrollListener);
    paymentProvider.addListener(() {
      if (paymentProvider.isFinishPaying == true) {
        chatProvider.deletePinnedById(paymentProvider.payedPost);
      }
    });
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

  void connect() {
    socket = IO.io('ws://167.99.125.80:3000/', <String, dynamic>{
      "transports": ['websocket'],
      "autoconect": false,
    });
    socket.connect();
    socket.onConnect((_) {
      print("Connected to frontend");
    });

    socket.on('message', (message) async {
      final participant1ID = message['participant1_id'];
      final participant2ID = message['participant2_id'];

      final userId = await getUserId();
      final receiverId = widget.receiverId;

      // Check if the message is intended for the current user
      if ((participant1ID == userId && participant2ID == receiverId) ||
          (participant2ID == userId && participant1ID == receiverId)) {
        final newMessage = Message.fromJson(message);

        chatProvider.addMessage(newMessage);
      } else {
        print("Discarding message as it is not intended for the current user.");
      }
    });
  }

  Future<void> _sendMessageToSocket(Map<String, dynamic> rawMessage) async {
    if (socket.connected) {
      try {
        rawMessage['participant1_id'] = await getUserId();
        rawMessage['participant2_id'] = widget.receiverId;
        rawMessage['is_read'] = 0;
        socket.emit('chat_message', rawMessage);
      } catch (e) {
        print("Error sending message via WebSocket: $e");
      }
    } else {
      print("WebSocket is not connected. Message not sent.");
    }
  }

  void _getThisUsersMessages() async {
    final res = widget.receiverId;
    print("Loading messages for: ${await getUserId()} and $res");
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.getMessages(context, await getUserId(), res);

    setState(() {
      if (_scrollController.hasClients && _shouldAutoscroll) {
        _scrollToBottom();
      }

      if (!_firstAutoscrollExecuted && _scrollController.hasClients) {
        _scrollToBottom();
      }
    });
  }

  void _sendMessage(messageText, String messageType) async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    if (messageType == "text") {
      chatProvider.sendMessage(context, await getUserId(), widget.receiverId,
          messageText, chatProvider, socket);
    } else if (messageType == "image") {
      chatProvider.sendImageMessage(context, await getUserId(),
          widget.receiverId, File(messageText), chatProvider, socket);
    } else {
      chatProvider.sendVideoMessage(context, await getUserId(),
          widget.receiverId, File(messageText), chatProvider, socket);
    }

    setState(() {
      if (_scrollController.hasClients && _shouldAutoscroll) {
        _scrollToBottom();
      }

      if (!_firstAutoscrollExecuted && _scrollController.hasClients) {
        _scrollToBottom();
      }
    });
  }

  void markMessageAsReadHere(message) async {
    if (message.isReady == 0 && message.senderId != await getUserId()) {
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
                              final userId = userIdSnapshot.data;
                              final isSender = message.senderId == userId;

                              return MSG.Message(
                                message: ChatMessage(
                                    text: messages[index].message,
                                    messageType: messages[index].messageType ==
                                            "image"
                                        ? ChatMessageType.image
                                        : messages[index].messageType == "video"
                                            ? ChatMessageType.video
                                            : ChatMessageType.text,
                                    messageStatus: message.isReady == 0
                                        ? MessageStatus.not_view
                                        : MessageStatus.viewed,
                                    isSender: isSender,
                                    id: messages[index].id,
                                    isReady: messages[index].isReady,
                                    userImage: widget.userImage),
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
            textCapitalization:TextCapitalization.sentences,
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: "Type message",
              border: InputBorder.none,
            ),
            onSubmitted: (_) {
              _sendMessage(_textEditingController.text, "text");
              _textEditingController.clear();
            }, // Submit action
          ),
        ),
        GestureDetector(
          onTap: () {
            _sendMessage(_textEditingController.text, "text");
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
                Provider.of<ChatProvider>(context, listen: false)
                    .setShouldRefresh(true);
              },
              child: Icon(Icons.arrow_back, color: Colors.black, size: 33),
            ),
          ),
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
                widget.userImage), // You can use a placeholder image
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
      _previewImageAndSend(result.path);
    }
  }

  void _previewImageAndSend(String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.file(File(imagePath)),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Send"),
              onPressed: () async {
                final cp = Provider.of<ChatProvider>(context, listen: false);
                // cp.sendImageMessage(context, await getUserId(), widget.receiverId, File imagePath, cp, socket);
                _sendMessage(imagePath, 'image');
                print("Message sent.");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleVideoSelection() async {
    final result = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    if (result == null) {
      return;
    }

    // Check video size
    File videoFile = File(result.path);
    int videoSizeInBytes = await videoFile.length();
    double videoSizeInMB = videoSizeInBytes / (1024 * 1024);

    // Check video duration
    final videoPlayerController = VideoPlayerController.file(videoFile);
    await videoPlayerController.initialize();
    final duration = videoPlayerController.value.duration;
    print(result);
    print(
        "The selected vide00000 is ${videoSizeInMB}MB and its duration is ${duration.inSeconds} seconds.");

    if (videoSizeInMB > 10) {
      final snackBar = SnackBar(
        content: Text('Video size should not be more than 10MB.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (duration > Duration(minutes: 3)) {
      final snackBar = SnackBar(
        content: Text('Video duration should not be more than 3 minutes.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    try {
      final cp = Provider.of<ChatProvider>(context, listen: false);
      _sendMessage(result.path, 'video');
      print("Message sent.");
    } catch (error) {
      final snackBar = SnackBar(
        content: Text('Error: $error'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

Future<Null> buildMessagePayment(BuildContext context, price, postId) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    builder: (BuildContext context) {
      return Builder(
        builder: (BuildContext innerContext) {
          return Consumer<MessagePaymentProvider>(
            builder: (context, messagePaymentProvider, _) {
              final userProvider = Provider.of<UserProvider>(innerContext);
              final TextEditingController phoneNumberController =
                  TextEditingController(
                text: userProvider.userData['phone_number'].toString(),
              );
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(
                        child: Text(
                          'Pay to Chat $price Tshs',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      textCapitalization:TextCapitalization.sentences,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone number',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.phone),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                    ),
                    Center(
                      child: messagePaymentProvider.isPaying
                          ? LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.red, size: 30)
                          : TextButton(
                              onPressed: () async {
                                messagePaymentProvider.startPaying(
                                    userProvider.userData['phone_number']
                                        .toString(),
                                    price,
                                    postId,
                                    'message');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text(
                                'Pay',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  ).then((result) {
    var messagePaymentProvider =
        Provider.of<MessagePaymentProvider>(context, listen: false);
    messagePaymentProvider.paymentCanceled = true;
    print(messagePaymentProvider.isPaying);
    print('Modal bottom sheet closed: $result');
  });
}

Future<Null> buildSubscriptionPayment(BuildContext context, price, userId) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    builder: (BuildContext context) {
      return Builder(
        builder: (BuildContext innerContext) {
          return Consumer<SubscriptionPaymentProvider>(
            builder: (context, subscriptionPaymentProvider, _) {
              final userProvider = Provider.of<UserProvider>(innerContext);
              final TextEditingController phoneNumberController =
                  TextEditingController(
                text: userProvider.userData['phone_number'].toString(),
              );
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(
                        child: Text(
                          'Pay $price Tshs to Subscribe ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                    //SizedBox(height: 10.0), // Add some space between price and text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(
                        child: Text(
                          '(One Month Period)', // Text indicating the duration
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      textCapitalization:TextCapitalization.sentences,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone number',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.phone),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                    ),
                    Center(
                      child: subscriptionPaymentProvider.isPaying
                          ? LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.red, size: 30)
                          : TextButton(
                              onPressed: () async {
                                subscriptionPaymentProvider.startPaying(
                                    userProvider.userData['phone_number']
                                        .toString(),
                                    price,
                                    userId,
                                    'subscription');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text(
                                'Pay',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  ).then((result) {
    var messagePaymentProvider =
        Provider.of<MessagePaymentProvider>(context, listen: false);
    messagePaymentProvider.paymentCanceled = true;
    print(messagePaymentProvider.isPaying);
    print('Modal bottom sheet closed: $result');
  });
}

Future<Null> showSubscriptionInfo(BuildContext context,mySubscribeDays) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    builder: (BuildContext context) {
      return Builder(
        builder: (BuildContext innerContext) {
          return Consumer<SubscriptionPaymentProvider>(
            builder: (context, subscriptionPaymentProvider, _) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(
                        child: Text(
                          'Subscription Days Remaining: $mySubscribeDays',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  ).then((result) {
    var messagePaymentProvider =
    Provider.of<MessagePaymentProvider>(context, listen: false);
    messagePaymentProvider.paymentCanceled = true;
    print(messagePaymentProvider.isPaying);
    print('Modal bottom sheet closed: $result');
  });
}
