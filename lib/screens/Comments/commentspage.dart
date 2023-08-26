import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bangapp/services/service.dart';


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
    bottomLeft: Radius.circular(32),
  ),
);

class CommentsPage extends StatefulWidget {
  static const String id = 'comment_screen';
  final int? userId;
  final postId;
  final _MessageStreamState? messageStreamState;
  const CommentsPage({
    Key? key,
    required this.userId,
    this.postId,
    this.messageStreamState,
  }) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final messageTextController = TextEditingController();
  late String commentText;
  final TextEditingController _controller = TextEditingController();
  bool _showEmojiPicker = false; // Flag to control emoji picker visibility

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showEmojiPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.35, // Set your desired height here

          child: EmojiPicker(
            textEditingController: _controller,
            onBackspacePressed: _onBackspacePressed,
            config: Config(
              columns: 7,
              emojiSizeMax: 32 *
                  (foundation.defaultTargetPlatform == TargetPlatform.iOS
                      ? 1.30
                      : 1.0),
            ),
          ),
        );
      },
    );
  }

  _onBackspacePressed() {
    _controller
      ..text = _controller.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  void _onEmojiSelected(Category? category, Emoji emoji) {
    _controller.text += emoji.emoji;
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
          icon: Icon(CupertinoIcons.back),
        ),
        title: Text(
          'Comments',
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //MessageStream widget or any other content you have

            //Use the Visibility widget to show or hide the emoji picker
            Visibility(
              visible: _showEmojiPicker,
              //size of the keyboard
                child: SizedBox(
                  height:  MediaQuery.of(context).size.height * .35,
                  child: EmojiPicker(
                    onEmojiSelected: _onEmojiSelected,
                    config: Config(
                      columns: 7,
                    ),
                  ),
                ),

            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: kMessageContainerDecoration,
          child: TextField(
            controller: messageTextController,
            onChanged: (value) {
              commentText = value;
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              prefixIcon: GestureDetector(
                onTap: () {
                  // Call the function to show the emoji picker
                  showEmojiPicker(context);
                },
                child: Icon(Icons.emoji_emotions_outlined),
              ),
              suffixIcon: Icon(Icons.camera_alt),
              hintText: 'Type a message',
              hintStyle: TextStyle(
                height: 1.5,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    ),
    TextButton(
                  onPressed: () {
                    Service().postComment(widget.postId, commentText).then(
                          (response) {
                        print('martin');
                        print(response['data']);
                        final newComment = {
                          'body': response['data']['body'],
                          'user': {
                            'name': response['data']['user']['name'],
                            'image': response['data']['user']['image'],
                          },
                        };
                        widget.messageStreamState?.addComment(newComment);
                        // MessageStream.of(context).addComment(newComment);
                      },
                    );
                  },
                  child: CircleAvatar(
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.red,
                    radius: 25,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String url;
  final String sender;

  MessageBubble({
    required this.text,
    required this.sender,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(url),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sender,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Metropolis',
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(minWidth: 0, maxWidth: 200),
                      child: Text(
                        text ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Metropolis',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Reply',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FaIcon(
                        FontAwesomeIcons.heart,
                        color: Colors.black,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageStream extends StatefulWidget {
  final postID;

  MessageStream({required this.postID,  _MessageStreamState? messageStreamState});

  @override
  _MessageStreamState createState() => _MessageStreamState();

  static _MessageStreamState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MessageStreamState>();
  }
}

class _MessageStreamState extends State<MessageStream> {
  List<dynamic> comments = [];
  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final List<dynamic> initialComments =
    await Service().getComments(widget.postID.toString());
    setState(() {
      comments = initialComments;
    });
  }

  void addComment(dynamic newComment) {
    setState(() {
      comments.add(newComment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];
          final commentText = comment['body'];
          final commentSender = comment['user']['name'];
          final profileUrl = comment['user']['image'];
          return MessageBubble(
            url: profileUrl,
            text: commentText,
            sender: commentSender,
          );
        },
      ),
    );
  }
}
