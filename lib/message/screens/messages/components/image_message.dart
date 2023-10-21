import 'package:bangapp/message/models/ChatMessage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageMessage extends StatelessWidget {
  final ChatMessage? message;
  final Color playIconColor;

  const ImageMessage({
    Key? key,
    this.playIconColor = Colors.white,
    this.message,
  }) : super(key: key);

  void _showImagePreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: CachedNetworkImage(imageUrl: message!.text),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(message!.text);
    print("jjjjjjjjjjjjjjjjjjj");
    print("Tyopof");

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InkWell(
              onTap: () {
                _showImagePreview(context);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: message!.text,
                  placeholder: (context, url) {
                    return Container(
                        width: 100,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.grey[200]!,
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
