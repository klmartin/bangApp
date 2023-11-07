import 'package:bangapp/message/models/ChatMessage.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:emoji_regex/emoji_regex.dart';


import '../../../constants.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: MediaQuery.of(context).platformBrightness == Brightness.dark
        //     ? Colors.white
        //     : Colors.black,
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 0.75,
          vertical: kDefaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(message!.isSender ? 1 : 0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child:Text(
  formatText(message!.text),
  style: TextStyle(
    color: message!.isSender
      ? Colors.white
      : Theme.of(context).textTheme.bodyLarge!.color,
  ),
  maxLines: null, // Allow unlimited lines
  overflow: TextOverflow.clip, // Clip overflowed text
));

  }
}


String formatText(String? text) {
  if (text == null) return '';

  final words = text.split(RegExp(r'(\s+)'));
  var formattedText = '';
  var wordCount = 0;
  var emojiClusterCount = 0;

  for (var word in words) {
    if (word.trim().isEmpty) continue;

    if (isEmojiCluster(word)) {
      emojiClusterCount++;

      if (emojiClusterCount == 3) {
        formattedText += word; // Add the third emoji to the cluster
        wordCount++;
        emojiClusterCount = 0;
      } else {
        formattedText += word;
      }
    } else {
      formattedText += word;
      wordCount++;
    }

    if (wordCount % 5 == 0 && wordCount < words.length) {
      formattedText += '\n'; // Add a line break after every 6 words or emoji clusters
    } else {
      formattedText += ' ';
    }
  }

  return formattedText.trim(); // Trim any leading/trailing spaces
}

bool isEmojiCluster(String word) {
  final emojiRegex = RegExp(
    r'(\p{Extended_Pictographic}){1,3}', // Matches 1 to 3 emoji characters
    unicode: true,
  );
  return emojiRegex.hasMatch(word);
}



class EmojiText extends StatelessWidget {

  const EmojiText({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: _buildText(this.text),
    );
  }

  TextSpan _buildText(String text) {
    final children = <TextSpan>[];
    final runes = text.runes;

    for (int i = 0; i < runes.length; /* empty */ ) {
      int current = runes.elementAt(i);

      // we assume that everything that is not
      // in Extended-ASCII set is an emoji...
      final isEmoji = current > 255;
      final shouldBreak = isEmoji
        ? (x) => x <= 255
        : (x) => x > 255;

      final chunk = <int>[];
      while (! shouldBreak(current)) {
        chunk.add(current);
        if (++i >= runes.length) break;
        current = runes.elementAt(i);
      }

      children.add(
        TextSpan(
          text: String.fromCharCodes(chunk),
          style: TextStyle(
            fontFamily: isEmoji ? 'EmojiOne' : null,
          ),
        ),
      );
    }

    return TextSpan(children: children);
  }
}
