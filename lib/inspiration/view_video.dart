import 'package:bangapp/inspiration/video_container.dart';
import 'package:bangapp/widgets/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:bangapp/providers/inprirations_Provider.dart';

import 'package:provider/provider.dart';

class ViewVideo extends StatefulWidget {
  int inspirationVideoId;
  final String? title;
  final String? profileUrl;
  final String? videoUrl;
  final String? thumbnail;

  ViewVideo(this.inspirationVideoId, this.title, this.profileUrl, this.videoUrl,
      this.thumbnail);

  @override
  State<ViewVideo> createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {
  @override
  void initState() {
    final pro = context.read<BangInspirationsProvider>();
    pro.fetchInspirations(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Video id is::::::::::::::::::: ${widget.videoUrl.toString()}");
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Column(children: [
        SizedBox(
          height: 50,
        ),
        Container(
          child: Column(
            children: [
              VideoPlayerPage(mediaUrl: widget.videoUrl.toString()),
              Container(
                padding: EdgeInsets.only(top:10, bottom: 10, left: 0),
                child: Text(
                  widget.title.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.white,
          indent: 10,
          endIndent: 10,
        ),
        Container(
          padding: EdgeInsets.only(top: 15, left: 19, bottom: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Other Videos",
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
        ),
        Expanded(
          // ...

          child: Consumer<BangInspirationsProvider>(
            builder: (context, provider, child) {
              return ListView.builder(
                itemCount: provider.inspirations.length,
                itemBuilder: (context, index) {
                  final inspiration = provider.inspirations[index];
                  return VideoContainer(
                    inspirationVideoId: inspiration.id,
                    // videoLink: inspiration.videoUrl ??
                    //     'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                    videoLink:
                        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4",

                    thumbnail: inspiration.thumbnail ??
                        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg',
                    channelName: 'The Codeholic',
                    pubDate: '9 days ago',
                    videotitle: inspiration.title ?? 'Default Title',
                    viewsCount: '98.8 views',
                    channelIcon: 'assets/images/app_icon.jpg',
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}
