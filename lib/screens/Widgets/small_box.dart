import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../services/animation.dart';
import 'package:ionicons/ionicons.dart';
import 'package:bangapp/screens/Widgets/battle_like.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bangapp/services/service.dart';

class SmallBoxCarousel extends StatefulWidget {
  @override
  _SmallBoxCarouselState createState() => _SmallBoxCarouselState();
}

class _SmallBoxCarouselState extends State<SmallBoxCarousel> {
  List<BoxData> boxes = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<BoxData> data = await Service().getBangBattle();
    setState(() {
      boxes = data;
    });
  }

  void viewImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: SizedBox.expand(
            child: Hero(
              tag: imageUrl,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '     Bang Battle',
          style: TextStyle(fontFamily: 'Metropolis',
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              letterSpacing: -1),

        ),

        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            viewportFraction: 1.0,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 7),
          ),
          items: boxes.map((box) {
            if(box.imageUrl2 != null){
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.0),
                    child: Column(
                      children: [
                        Row(  // Replace Column with Row
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  viewImage(context, box.imageUrl1);
                                },
                                child: Container(
                                  height: 200,
                                  child: Image.network(
                                    box.imageUrl1,  // Replace with the URL of the first image
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 10),  // Add some spacing between the images
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  viewImage(context, box.imageUrl2);
                                },
                                child: Container(
                                  height: 200,
                                  child: Image.network(
                                    box.imageUrl2,  // Replace with the URL of the first image
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          box.text,
                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child:BattleLike(likeCount: 0,isLiked:false,battleId: box.battleId, bLikeButton: false,)
                        ),
                      ],
                    ),
                  );
                },
              );

            }
            else{
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            viewImage(context, box.imageUrl1);
                          },
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            child: Image.network(
                              box.imageUrl1,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        SizedBox(height: 10),
                        Text(
                          box.text,
                          style: TextStyle(fontSize: 12),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: BattleLike(likeCount: 0,isLiked:false,battleId: box.battleId, bLikeButton: true,),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

          }).toList(),
        ),
      ],
    );
  }


}

class BoxData {
  final String imageUrl1;
  final String imageUrl2;
  final String text;
  final int battleId;

  BoxData({ required this.imageUrl1, required this.imageUrl2,  required this.text,required this.battleId});

  factory BoxData.fromJson(Map<String, dynamic> json) {
    return BoxData(
      imageUrl1: json['battle1'],
      imageUrl2: json['battle2'],
      text: json['body'],
      battleId: json['id'],
    );
  }
}
