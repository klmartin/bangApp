import 'package:bangapp/widgets/build_media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:bangapp/providers/BoxDataProvider.dart'; // Import the BoxDataProvider
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:bangapp/widgets/video_player.dart';
import '../../services/service.dart';
import '../Comments/battleComment.dart';

class SmallBoxCarousel extends StatefulWidget {
  @override
  _SmallBoxCarouselState createState() => _SmallBoxCarouselState();
}

class _SmallBoxCarouselState extends State<SmallBoxCarousel> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BoxDataProvider>(context, listen: false);
    provider.fetchData();
  }

  void viewImage(BuildContext context, String imageUrl) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => Scaffold(
        body: SizedBox.expand(
          child: Hero(
            tag: imageUrl,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ZoomableImage(imageUrl: imageUrl),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

  buildFab(value, BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Center(
                  child: Text(
                    'Pinned battle',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  CupertinoIcons.circle_fill,
                  color: Colors.orange.shade600,
                  size: 25.0,
                ),
                title: Text('Pay to Vote'),
                trailing: Text('500 tshs'),
                // subtitle: Text('to Vote'),
                onTap: () {
                  Navigator.pop(context);
                  buildPayments('value', context);
                },
              ),

            ],
          ),
        );
      },
    );
  }

  buildPayments(value, BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Center(
                  child: Text(
                    'Packages',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  CupertinoIcons.circle_fill,
                  color: Colors.blue.shade600,
                  size: 25.0,
                ),
                title: Text('Tigo Pesa'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  CupertinoIcons.circle_fill,
                  color: Colors.red.shade600,
                  size: 25.0,
                ),
                title: Text('Airtel Money'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  CupertinoIcons.circle_fill,
                  color: Colors.red,
                  size: 25.0,
                ),
                title: Text('M-pesa'),
                onTap: () async {},
              ),
              ListTile(
                leading: Icon(
                  CupertinoIcons.circle_fill,
                  color: Colors.yellowAccent,
                  size: 25.0,
                ),
                title: Text('Halo-pesa'),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
  @override

  Widget build(BuildContext context) {
    double halfScreenWidth = MediaQuery.of(context).size.width / 2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '     Bang Battle',
          style: TextStyle(
            fontFamily: 'Metropolis',
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
          ),
        ),
        Consumer<BoxDataProvider>(
          builder: (context, provider, child) {
            final boxes = provider.boxes;
            return boxes.isEmpty
                ? Center(child: CircularProgressIndicator())
                : CarouselSlider(
                    options: CarouselOptions(
                      height: 280,
                      viewportFraction: 1.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 7),
                    ),
                    items: boxes.map((box) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 1.0),
                            child: Column(
                              children: [
                              Row(
                                children: [
                                if(box.type=='image')
                                GestureDetector(
                                    onTap: () {
                                    viewImage(context, box.imageUrl1);
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 200,
                                          width: halfScreenWidth - 8 ,
                                          child: CachedNetworkImage(
                                            imageUrl: box.imageUrl1,
                                            placeholder: (context, url) => AspectRatio(
                                              aspectRatio: 200 / 200,
                                              child: Shimmer.fromColors(
                                                baseColor:
                                                const Color.fromARGB(255, 30, 34, 45),
                                                highlightColor:
                                                const Color.fromARGB(255, 30, 34, 45)
                                                    .withOpacity(.85),
                                                child: Container(
                                                    color: const Color.fromARGB(
                                                        255, 30, 34, 45)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 5,
                                          child: Container(
                                            margin: EdgeInsets.only(left: 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            child: Text(
                                              "A",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 34,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                SizedBox(width: 5),
                                  GestureDetector(
                                  onTap: () {
                                  viewImage(context, box.imageUrl2);
                                  },
                                  child: Stack(
                                  children: [
                                  Container(
                                  height: 200,
                                  width:halfScreenWidth - 5 ,
                                  child: CachedNetworkImage(
                                    imageUrl: box.imageUrl2,
                                    placeholder: (context, url) => AspectRatio(
                                      aspectRatio: 200 / 200,
                                      child: Shimmer.fromColors(
                                        baseColor:
                                        const Color.fromARGB(255, 30, 34, 45),
                                        highlightColor:
                                        const Color.fromARGB(255, 30, 34, 45)
                                            .withOpacity(.85),
                                        child: Container(
                                            color: const Color.fromARGB(
                                                255, 30, 34, 45)),
                                      ),
                                    ),
                                  ),
                                  ),
                                  Positioned(
                                    bottom: 5, right: 0,
                                    child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Text(
                                    "B",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 34,
                                            ),
                                         ),
                                       ),
                                      ),
                                    ),
                                  ],
                                  ),
                              ),
                              if(box.type=='video')
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                          builder: (context) => Scaffold(
                                          appBar: AppBar(
                                            backgroundColor: Colors.white,
                                            leading: IconButton(
                                              onPressed: () => Navigator.pop(context),
                                              icon: Icon(
                                                CupertinoIcons.back,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          body: VideoPlayerPage(
                                              mediaUrl: box.imageUrl1
                                          )
                                          )));
                                          // MaterialPageRoute(builder: (context) => VideoPlayerPage(mediaUrl: box.imageUrl1)));
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 200,
                                          width: halfScreenWidth - 8 ,
                                          child: CachedNetworkImage(
                                            imageUrl: box.coverImage,
                                            placeholder: (context, url) => AspectRatio(
                                              aspectRatio: 200 / 200,
                                              child: Shimmer.fromColors(
                                                baseColor:
                                                const Color.fromARGB(255, 30, 34, 45),
                                                highlightColor:
                                                const Color.fromARGB(255, 30, 34, 45)
                                                    .withOpacity(.85),
                                                child: Container(
                                                    color: const Color.fromARGB(
                                                        255, 30, 34, 45)),
                                              ),
                                            ),
                                          ),                                        ),
                                        Positioned(
                                          bottom: 5,
                                          child: Container(
                                            margin: EdgeInsets.only(left: 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            child: Text(
                                              "A",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 34,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {

                                    Navigator.push(context,
                                        MaterialPageRoute(
                                        builder: (context) => Scaffold(
                                        appBar: AppBar(
                                          backgroundColor: Colors.white,
                                          leading: IconButton(
                                            onPressed: () => Navigator.pop(context),
                                            icon: Icon(
                                              CupertinoIcons.back,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        body: VideoPlayerPage(
                                            mediaUrl: box.imageUrl2
                                        ))));
                                        // MaterialPageRoute(builder: (context) => VideoPlayerPage(mediaUrl: box.imageUrl2)));
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 200,
                                        width:halfScreenWidth - 5 ,
                                        child: CachedNetworkImage(
                                          imageUrl: box.coverImage2,
                                          placeholder: (context, url) => AspectRatio(
                                            aspectRatio: 200 / 200,
                                            child: Shimmer.fromColors(
                                              baseColor:
                                              const Color.fromARGB(255, 30, 34, 45),
                                              highlightColor:
                                              const Color.fromARGB(255, 30, 34, 45)
                                                  .withOpacity(.85),
                                              child: Container(
                                                  color: const Color.fromARGB(
                                                      255, 30, 34, 45)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 5, right: 0,
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            child: Text(
                                              "B",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 34,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                                Text(
                                  box.text,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if(box.pinned){
                                                print('this is pinned');
                                                buildFab(1, context);
                                              }
                                              else{
                                                final countUpdate =
                                                Provider.of<BoxDataProvider>(
                                                    context,
                                                    listen: false);
                                                Service().likeBattle(box.postId, "A");
                                                countUpdate.increaseLikes(
                                                    box.postId, 1);
                                              }

                                            },
                                            child: box.isLikedA
                                                ? Icon(
                                                    CupertinoIcons.heart_fill,
                                                    color: Colors.red,
                                                    size: 25)
                                                : Icon(CupertinoIcons.heart,
                                                    color: Colors.red,
                                                    size: 25),
                                          ),
                                          Text("${box.likeCountA} Likes")
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (builder) =>
                                                        BattleComment(
                                                          postId: box.postId,
                                                        )));
                                          },
                                          child: Text(
                                              "${box.commentCount} Comments"),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (builder) =>
                                                            BattleComment(
                                                              postId: box.postId,
                                                            )));
                                              },
                                              child: const Icon(
                                                CupertinoIcons.chat_bubble,
                                                color: Colors.black,
                                                size: 25,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if(box.pinned){
                                                  print('this is pinned');
                                                  buildFab(1, context);
                                                }
                                                else{
                                                  final countUpdate = Provider.of<
                                                      BoxDataProvider>(
                                                      context,
                                                      listen: false);
                                                  Service().likeBattle(
                                                      box.postId, "B");
                                                  countUpdate.increaseLikes(
                                                      box.postId, 2);
                                                }

                                                // Service().likeAction(postId, "A");
                                              },
                                              child: box.isLikedB
                                                  ? Icon(
                                                      CupertinoIcons.heart_fill,
                                                      color: Colors.red,
                                                      size: 25)
                                                  : Icon(CupertinoIcons.heart,
                                                      color: Colors.red,
                                                      size: 25),
                                            ),
                                            SizedBox(
                                              width: 7,
                                            ),
                                          ],
                                        ),
                                        Text("${box.likeCountB} Likes")
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
          },
        ),
      ],
    );
  }
}
