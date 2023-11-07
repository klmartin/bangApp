import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:bangapp/screens/Profile/user_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bangapp/screens/Profile/edit_my_profile.dart';
import 'package:http/http.dart' as http;
import 'package:bangapp/screens/Story/storyview.dart';
import 'package:bangapp/screens/settings/settings.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/userprovider.dart';
import '../Posts/postView_model.dart';
import '../Posts/post_challenge_view.dart';
import '../Posts/post_video_challenge_view.dart';
import 'profile_upload.dart';
import 'package:bangapp/models/image_post.dart';
import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/services/service.dart';
import 'package:provider/provider.dart';


class Profile extends StatefulWidget {
  final int? id;
  const Profile({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ScrollController? _scrollController;
  bool _isLoading = false;
  late String myName = "";
  late String myBio= "";
  late String myImage = profileUrl;
  late int myPostCount= 0;
  late int myFollowerCount= 0;
  late int myFollowingCount= 0;
  late String description= "";
  final int _numberOfPostsPerRequest = 20;
  int _pageNumber = 1;
  List<ImagePost> allImagePosts = [];
  void initState() {
    super.initState();
    _getMyInfo();
    _scrollController = ScrollController();
    _scrollController?.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (!_isLoading && _scrollController!.position.extentAfter < 200.0) {
      // Load more posts when the user is close to the end of the list
      _pageNumber++;
      _loadMorePosts();
    }
  }

  void _getMyInfo() async {
    var myInfo = await Service().getMyInformation();
    print(myInfo);
    print('this is my info');
    setState(() {
      myName =  myInfo['name'] ?? "";
      myBio = myInfo['bio'] ?? "";
      myImage = myInfo['user_image_url'] ?? "";
      myPostCount = myInfo['postCount'] ?? 0;
      myFollowerCount = myInfo['followerCount'] ?? 0;
      myFollowingCount = myInfo['followingCount'] ?? 0;
    });
  }

  void _loadMorePosts() async {
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final List<dynamic> newPosts = await getMyPosts(_pageNumber);
    setState(() {
      _isLoading = false;
      // Append the newly loaded posts to the existing list
      allImagePosts.addAll(newPosts.map((post) {
        return ImagePost(post['user']['name'],
            post['body'] ??"",
            post['image'],
            post['challenge_img']??"",
            post['width'],
            post['height'],
            post['id'],
            post['commentCount'],
            post['user_id'],
            post['isLikedA'],
            post['like_count_A'],
            post['type'],
            post['user']['followerCount'],
            post['created_at'],
            post['user_image_url'],
            post['pinned']
        );
      }));
    });
  }

  Future<List<dynamic>> getMyPosts(int pageNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getInt('user_id').toString());
    var userId = prefs.getInt('user_id').toString();
    var response = await http.get(Uri.parse("$baseUrl/getMyPosts?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest&user_id=$userId"));
    print(response.body);
    var data = json.decode(response.body);
    return data['data']['data'];
  }

  Future<String?> _generateThumbnail(String file, BuildContext context) async {
    final thumbnailAsUint8List = await VideoThumbnail.thumbnailFile(
      video: file,
      imageFormat: ImageFormat.WEBP,
      maxWidth: 320,
      quality: 50,
    );
    final thumbnailModel = Provider.of<ThumbnailModel>(context, listen: false);
    thumbnailModel.setThumbnailData(thumbnailAsUint8List);
    return thumbnailAsUint8List;
  }


  @override
  Widget build(BuildContext context) {
    // Build your UI using the imagePosts list
    return ChangeNotifierProvider(
      create: (context) => ThumbnailModel(),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          controller: _scrollController,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, bottom: 10.0),
                  child: Container(
                      width: 80,
                      height: 80,
                      decoration:  BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(myImage) ,
                            fit: BoxFit.cover,
                          )),
                      child: rimage != null
                          ? Image.file(
                        rimage,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                          : Container()),
                ),
                SizedBox(width: 150),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, bottom: 10.0),
                  child: InkWell(
                    // onTap: () {
                    //   openFilterDialog();
                    // },
                    child: Column(
                      children: [
                        Icon(
                          Ionicons.person_add_outline,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary,
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
                myName,
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
                    text: myBio),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => EditPage()));
                          },
                          child: Text(
                            'Edit profile',
                            style: TextStyle(color: Colors.black),
                          )),
                    )),
                SizedBox(width: 10),
                Expanded(
                    child: Container(
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>  AppSettings(),) );
                          },
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
                          // '$posts',
                          myPostCount.toString(),
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
                          myFollowerCount.toString(),
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
                          myFollowingCount.toString(),
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
            FutureBuilder(
              future: getMyPosts(_pageNumber),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlue,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  String thumbnailPath = ''; // Variable to store the thumbnail file path
                  final List<dynamic> posts = snapshot.data! as List<dynamic>;
                  for (var post in posts) {
                    final imagePost = ImagePost(
                        post['user']['name'],
                        post['body'] ?? "",
                        post['image'],
                        post['challenge_img'] ?? "",
                        post['width'],
                        post['height'],
                        post['id'],
                        post['commentCount'],
                        post['user_id'],
                        post['isLikedA'],
                        post['like_count_A'],
                        post['type'],
                        post['user']['followerCount'],
                        post['created_at'],
                        post['user_image_url'],
                        post['pinned']
                    );
                    allImagePosts.add(imagePost);
                  }
                }
                return allImagePosts.isEmpty
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'No photos yet',
                      style: TextStyle(fontFamily: 'Metropolis'),
                    )
                  ],
                )
                    : Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    children: [
                      for (var i = 0; i < allImagePosts.length; i++)
                        if(allImagePosts[i].type == 'image' && allImagePosts[i].challengeImgUrl=="" && allImagePosts[i].pinned == 0)
                        ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => POstView(
                                  allImagePosts[i].name,
                                  allImagePosts[i].caption,
                                  allImagePosts[i].imageUrl,
                                  allImagePosts[i].challengeImgUrl,
                                  allImagePosts[i].imgWidth,
                                  allImagePosts[i].imgHeight,
                                  allImagePosts[i].postId,
                                  allImagePosts[i].commentCount,
                                  allImagePosts[i].userId,
                                  allImagePosts[i].isLiked,
                                  allImagePosts[i].likeCount,
                                  allImagePosts[i].type,
                                  allImagePosts[i].followerCount,
                                  allImagePosts[i].createdAt,
                                  allImagePosts[i].userImage,
                                  allImagePosts[i].pinned
                              )));
                            },

                            child:
                              CachedNetworkImage(
                              imageUrl: allImagePosts[i].imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),]
                        else if(allImagePosts[i].type == 'image' && allImagePosts[i].challengeImgUrl!=""&& allImagePosts[i].pinned == 0)...[
                        ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                          onTap: () {
                          Navigator.push(
                          context, MaterialPageRoute(builder: (context) => POstChallengeView(
                            allImagePosts[i].name,
                            allImagePosts[i].caption,
                            allImagePosts[i].imageUrl,
                            allImagePosts[i].challengeImgUrl,
                            allImagePosts[i].imgWidth,
                            allImagePosts[i].imgHeight,
                            allImagePosts[i].postId,
                            allImagePosts[i].commentCount,
                            allImagePosts[i].userId,
                            allImagePosts[i].isLiked,
                            allImagePosts[i].likeCount,
                            allImagePosts[i].type,
                            allImagePosts[i].followerCount,
                            allImagePosts[i].createdAt,
                            allImagePosts[i].userImage,
                            allImagePosts[i].pinned
                          )));
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: CachedNetworkImage(
                                  imageUrl: allImagePosts[i].imageUrl,
                                ),
                              ),
                              Expanded(
                                child: CachedNetworkImage(
                                  imageUrl: allImagePosts[i].challengeImgUrl,
                                ),
                              ),
                            ],
                          )
                        ),
                        ),
                        ]
                        else if(allImagePosts[i].type == 'image' && allImagePosts[i].challengeImgUrl=="" && allImagePosts[i].pinned == 1) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => POstView(
                                      allImagePosts[i].name,
                                      allImagePosts[i].caption,
                                      allImagePosts[i].imageUrl,
                                      allImagePosts[i].challengeImgUrl,
                                      allImagePosts[i].imgWidth,
                                      allImagePosts[i].imgHeight,
                                      allImagePosts[i].postId,
                                      allImagePosts[i].commentCount,
                                      allImagePosts[i].userId,
                                      allImagePosts[i].isLiked,
                                      allImagePosts[i].likeCount,
                                      allImagePosts[i].type,
                                      allImagePosts[i].followerCount,
                                      allImagePosts[i].createdAt,
                                      allImagePosts[i].userImage,
                                      allImagePosts[i].pinned,
                                  )));
                                },
                                child:
                                Image.network(
                                  pinnedUrl,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                        ]
                        else if(allImagePosts[i].type == 'video' && allImagePosts[i].challengeImgUrl=="")...[

                          ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: InkWell(
                          onTap: () {
                          Navigator.push(
                          context, MaterialPageRoute(builder: (context) => POstView(
                          allImagePosts[i].name,
                          allImagePosts[i].caption,
                          allImagePosts[i].imageUrl,
                          allImagePosts[i].challengeImgUrl,
                          allImagePosts[i].imgWidth,
                          allImagePosts[i].imgHeight,
                          allImagePosts[i].postId,
                          allImagePosts[i].commentCount,
                          allImagePosts[i].userId,
                          allImagePosts[i].isLiked,
                          allImagePosts[i].likeCount,
                          allImagePosts[i].type,
                          allImagePosts[i].followerCount,
                          allImagePosts[i].createdAt,
                          allImagePosts[i].userImage,
                          allImagePosts[i].pinned
                          )));
                          },
                          child: FutureBuilder<String?>(
                            future: _generateThumbnail(allImagePosts[i].imageUrl, context), // Replace with your video file path
                            builder: (context, snapshot) {
                              print(snapshot);
                              print('this is data');
                              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                  final thumbnailModel = Provider.of<ThumbnailModel>(context);
                                  final thumbnailData = thumbnailModel.thumbnailData;
                                  return Image.asset(
                                    thumbnailData!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  );
                                }
                              else {
                                  return Image.asset(
                                  'assets/images/video_thumb.png',
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                              );
                            }
                            },
                          )

                          ),
                          ),
                        ]
                        else if(allImagePosts[i].type == 'video' && allImagePosts[i].challengeImgUrl!="")...[
                            ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                            onTap: () {
                            Navigator.push(
                            context, MaterialPageRoute(builder: (context) => POstVideoChallengeView(
                            allImagePosts[i].name,
                            allImagePosts[i].caption,
                            allImagePosts[i].imageUrl,
                            allImagePosts[i].challengeImgUrl,
                            allImagePosts[i].imgWidth,
                            allImagePosts[i].imgHeight,
                            allImagePosts[i].postId,
                            allImagePosts[i].commentCount,
                            allImagePosts[i].userId,
                            allImagePosts[i].isLiked,
                            allImagePosts[i].likeCount,
                            allImagePosts[i].type,
                            allImagePosts[i].followerCount,
                            allImagePosts[i].createdAt,
                            allImagePosts[i].userImage,
                            allImagePosts[i].pinned
                            )));
                            },
                            child: Row(
                            children: [
                            Expanded(
                            child: Image.asset(
                              'assets/images/video_thumb.png',
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                            ),
                            Expanded(
                            child: Image.asset(
                              'assets/images/video_thumb.png',
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                            ),
                            ],
                            )
                            ),
                            ),
                          ]
                    ]
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class Hobby {
  final String? name;
  final int ?id;
  final String? avatar;

  Hobby({this.name,this.id, this.avatar});

  factory Hobby.fromJson(Map<String, dynamic> json) {
    return Hobby(
      name: json['name'],
      id: json['id'],
      avatar: "", // You can set the avatar URL here if needed
    );
  }
}

class Highlights extends StatefulWidget {
  final String name;
  final String url;

  Highlights({required this.name, required this.url});

  @override
  _HighlightsState createState() => _HighlightsState();
}

class _HighlightsState extends State<Highlights> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Column(children: <Widget>[]),
    );
  }
}

Future<List<Hobby>> fetchHobbies() async {
  print('fetching hobbies');
  final response = await http.get(Uri.parse('$baseUrl/hobbies'));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);

    print(json.decode(response.body));
    return data.map((json) => Hobby.fromJson(json)).toList();

  } else {
    throw Exception('Failed to load hobbies');
  }
}

buildFab(value,BuildContext context) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child:Column(
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
                color:Colors.orange.shade600,
                size: 25.0,
              ),
              title: Text('Bronze'),
              trailing: Text('2,500 tshs'),
              subtitle: Text('500 followers'),
              onTap: () {
                Navigator.pop(context);
                buildPayments('value',context);
              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.circle_fill,
                color:Colors.grey,
                size: 25.0,
              ),
              title: Text('Silver'),
              trailing: Text('5,000 tshs'),
              subtitle: Text('1,100 followers'),
              onTap: () async {
                Navigator.pop(context);
                buildPayments('value',context);
              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.circle_fill,
                color:Colors.yellowAccent.shade400,
                size: 25.0,
              ),
              title: Text('Gold'),
              trailing: Text('10,000 tshs'),
              subtitle: Text('2,300 followers'),
              onTap: () {
                Navigator.pop(context);
                buildPayments('value',context);
              },
            ),
          ],
        ),
      );
    },
  );
}

buildPayments(value,BuildContext context) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child:Column(
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
                color:Colors.blue.shade600,
                size: 25.0,
              ),
              title: Text('Tigo Pesa'),
              onTap: () {

              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.circle_fill,
                color:Colors.red.shade600,
                size: 25.0,
              ),
              title: Text('Airtel Money'),
              onTap: () {

              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.circle_fill,
                color:Colors.red,
                size: 25.0,
              ),
              title: Text('M-pesa'),

              onTap: () async {

              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.circle_fill,
                color:Colors.yellowAccent,
                size: 25.0,
              ),
              title: Text('Halo-pesa'),
              onTap: () {

              },
            ),
          ],
        ),
      );
    },
  );
}

class Tagged extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[Text('No photos yet')],
      ),
    );
  }
}

class Highlight extends StatefulWidget {
  final String name;
  final String url;

  Highlight({required this.name, required this.url});

  @override
  _HighlightState createState() => _HighlightState();
}

class _HighlightState extends State<Highlight> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StoryPageView(key: null,)));
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: NetworkImage(widget.url), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            // padding: const EdgeInsets.fromLTRB(10.0, 5.0, 8.0, 5.0),
            padding: EdgeInsets.all(8.0),
            child: Text(
              widget.name,
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontSize: 11.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class ThumbnailModel with ChangeNotifier {
  String? thumbnailData;
  void setThumbnailData(String? data) {
    print(data);
    thumbnailData = data;
    notifyListeners();
  }
}
