import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for input text controller

import '../../../constants.dart';

class ChatInputField extends StatefulWidget {
  final Function(String message) onSendMessage; // Callback to send the message
  const ChatInputField({
    Key? key,
    required this.onSendMessage,
  }) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _textEditingController = TextEditingController();

  void _sendMessage() {
    final message = _textEditingController.text.trim();
    if (message.isNotEmpty) {
      // Validate and send the message if it's not empty
      widget.onSendMessage(message);
      // Clear the text input field after sending the message
      _textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Icon(
              Icons.attach_file,
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color!
                  .withOpacity(0.64),
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
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(), // Submit action
                      ),
                    ),
                    GestureDetector(
                      onTap: _sendMessage, // Send message on button tap
                      child: Icon(
                        Icons.send_outlined,
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .color!
                            .withOpacity(0.64),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
