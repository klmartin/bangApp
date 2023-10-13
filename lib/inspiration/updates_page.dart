import 'package:bangapp/inspiration/category.dart';
import 'package:bangapp/inspiration/video_container.dart';
import 'package:bangapp/providers/inprirations_Provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class BangInspirationBuilder extends StatefulWidget {
  const BangInspirationBuilder();

  @override
  State<BangInspirationBuilder> createState() => _BangInspirationBuilderState();
}

class _BangInspirationBuilderState extends State<BangInspirationBuilder> {
  @override
  void initState() {
    final pro = Provider.of<BangInspirationsProvider>(context, listen: false);
    pro.fetchInspirations(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BangInspirationsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (provider.inspirations.isEmpty) {
          return Center(
            child: Text('No inspirations found.'),
          );
        } else {
          return SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              padding: EdgeInsets.only(left: 5, right: 5, top: 5),
              child: Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 60,
                    child: Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Row(
                              children: [
                                SizedBox(width: 5),
                                Category1(
                                  catName: 'All',
                                ),
                                SizedBox(width: 5),
                                Category1(
                                  catName: 'Life',
                                ),
                                SizedBox(width: 5),
                                Category1(
                                  catName: 'Entertainment',
                                ),
                                SizedBox(width: 5),
                                Category1(
                                  catName: 'Business',
                                ),
                                SizedBox(width: 5),
                                Category1(
                                  catName: 'Live',
                                ),
                                SizedBox(width: 5),
                                Category1(
                                  catName: 'Business',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: provider.inspirations.length,
                    itemBuilder: (context, index) {
                      final inspiration = provider.inspirations[index];

                      return VideoContainer(
                        inspirationVideoId: inspiration.id,
                        // videoLink:  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4",
                        videoLink: inspiration.videoUrl ?? 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                        thumbnail:
                            inspiration.thumbnail ?? 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg',
                        channelName: 'The Codeholic',
                        pubDate: '9 days ago',
                        videotitle: inspiration.title ?? 'Default Title',
                        viewsCount: '98.8 views',
                        channelIcon: 'assets/images/app_icon.jpg',
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
