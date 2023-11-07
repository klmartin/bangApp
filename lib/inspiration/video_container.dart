import 'package:bangapp/inspiration/view_video.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class VideoContainer extends StatelessWidget {
  VideoContainer({
    required this.inspirationVideoId,
    required this.channelName,
    required this.pubDate,
    required this.thumbnail,
    required this.videotitle,
    required this.viewsCount,
    required this.channelIcon,
    required this.videoLink,
  });
  int inspirationVideoId;
  String videotitle;
  String channelName;
  String viewsCount;
  String pubDate;
  String thumbnail;
  String channelIcon;
  String videoLink;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Column(
        children: [
          Stack(
            children: [
              CachedNetworkImage(imageUrl: thumbnail),
              Positioned(
                top: 50,
                bottom: 50,
                left: 50,
                right: 50,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ViewVideo(
                          inspirationVideoId,
                           videotitle,
                             channelName,
                              videoLink,
                             viewsCount,


                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.red,
                    size: 80,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 22, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(channelIcon),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 280),
                      child: Text(
                        videotitle,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 2),
                  ],
                ),
                const Icon(Icons.more_vert, color: Colors.white),
              ],
            ),
          )
        ],
      ),
    );
  }
}
