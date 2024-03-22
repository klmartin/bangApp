import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:provider/provider.dart';
import 'package:bangapp/models/post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';

class ProfileHeaderSkeleton extends StatefulWidget {
  const ProfileHeaderSkeleton();

  @override
  State<ProfileHeaderSkeleton> createState() =>
      _ProfileHeaderSkeletonPageState();
}

class _ProfileHeaderSkeletonPageState extends State<ProfileHeaderSkeleton> {
  bool _enabled = true;
  bool _persposts = true;
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: _enabled,
      child: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20.0, bottom: 10.0),
                child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(""),
                          fit: BoxFit.cover,
                        )),
                    child:Container()),
              ),
              SizedBox(width: 150),
              Padding(
                padding: const EdgeInsets.only(right: 20.0, bottom: 10.0),
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      Icon(
                        Ionicons.person_add_outline,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 30,
                      ),
                      Text(
                        'Buy Followers',
                        style: TextStyle(
                          fontSize: 14.5,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Metropolis',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: RichText(
              overflow: TextOverflow.clip,
              strutStyle: StrutStyle(fontSize: 12.0),
              text: TextSpan(
                  style:
                      TextStyle(color: Colors.black, fontFamily: 'Metropolis'),
                  text: 'bio'),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      'Edit profile',
                      style: TextStyle(color: Colors.black),
                    )),
              )),
              SizedBox(width: 10),
              Expanded(
                  child: Container(
                child: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      'Settings',
                      style: TextStyle(color: Colors.black),
                    )),
              )),
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        '500',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Metropolis'),
                      ),
                    ),
                    Text(
                      'Posts',
                      style: TextStyle(fontFamily: 'Metropolis', fontSize: 12),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: FaIcon(
                    FontAwesomeIcons.ellipsisV,
                    size: 10,
                    color: Colors.grey,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        // '$followers',
                        "300",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Metropolis'),
                      ),
                    ),
                    Text(
                      'Followers',
                      style: TextStyle(fontFamily: 'Metropolis', fontSize: 12),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: FaIcon(
                    FontAwesomeIcons.ellipsisV,
                    size: 10,
                    color: Colors.grey,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        // '$following',
                        "40",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Metropolis'),
                      ),
                    ),
                    Text(
                      'Friends',
                      style: TextStyle(fontFamily: 'Metropolis', fontSize: 12),
                    )
                  ],
                ),
              ]),
          Container(
            width: 500,
            height: 500,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Material(
                          type: MaterialType
                              .transparency, //Makes it usable on any background color, thanks @IanSmith
                          child: Ink(
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: _persposts
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.5)),
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                            ),
                            child: InkWell(
                              //This keeps the splash effect within the circle
                              borderRadius: BorderRadius.circular(
                                  1000), //Something large to ensure a circle
                              onTap: () {
                                setState(() {
                                  _persposts = true;
                                });
                              },
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.thLarge,
                                    color:
                                        _persposts ? Colors.black : Colors.grey,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ),
                    Expanded(
                      child: Material(
                        type: MaterialType
                            .transparency, //Makes it usable on any background color, thanks @IanSmith
                        child: Ink(
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: _persposts
                                          ? Colors.grey
                                          : Colors.black,
                                      width: 0.5)),
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                            ),
                            child: InkWell(
                              //This keeps the splash effect within the circle
                              borderRadius: BorderRadius.circular(
                                  1000.0), //Something large to ensure a circle
                              onTap: () {
                                setState(() {
                                  _persposts = false;
                                });
                              },
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.userTag,
                                    size: 15,
                                    color:
                                        _persposts ? Colors.grey : Colors.black,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
