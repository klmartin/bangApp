import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bangapp/screens/Profile/edit_my_profile.dart';
import 'package:http/http.dart' as http;
import 'package:bangapp/screens/settings/settings.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/hobby.dart';
import '../../providers/Profile_Provider.dart';
import '../../providers/bangUpdate_profile_provider.dart';
import '../../widgets/video_rect.dart';
import '../Posts/postView_model.dart';
import '../Posts/post_challenge_view.dart';
import '../Posts/post_video_challenge_view.dart';
import 'profile_upload.dart';
import 'package:bangapp/models/image_post.dart';
import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/services/service.dart';

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
  late String myBio = "";
  int? phoneNumber;
  DateTime date_of_birth = DateTime.now();
  String selectedHobbiesText = "";
  String? occupation;
  late String myImage = profileUrl;
  late int myPostCount = 0;
  late int myFollowerCount = 0;
  late int myFollowingCount = 0;
  late String description = "";
  bool privacySwitchValue = false;
  final int _numberOfPostsPerRequest = 20;
  int _pageNumber = 1;
  bool _persposts = true;
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
    }
  }

  void _getMyInfo() async {
    var myInfo = await Service().getMyInformation();
    print(myInfo);
    print('this is my info');
    setState(() {
      date_of_birth = DateTime.parse(myInfo['date_of_birth']);
      myName = myInfo['name'] ?? "";
      myBio = myInfo['bio'] ?? "";
      phoneNumber = myInfo['phone_number'] ?? 0;
      selectedHobbiesText = myInfo['hobbies_and_interests'] ?? '';
      myImage = myInfo['user_image_url'] ?? "";
      occupation = myInfo['occupation'] ?? '';
      myPostCount = myInfo['postCount'] ?? 0;
      myFollowerCount = myInfo['followerCount'] ?? 0;
      myFollowingCount = myInfo['followingCount'] ?? 0;
      privacySwitchValue = myInfo['public'] == 1 ? true : false;
    });
  }


  Future<List<dynamic>> getMyPosts(int pageNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getInt('user_id').toString());
    var userId = prefs.getInt('user_id').toString();
    var response = await http.get(Uri.parse(
        "$baseUrl/getMyPosts?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest&user_id=$userId"));
    print(response.body);
    var data = json.decode(response.body);
    return data['data']['data'];
  }


  @override
  Widget build(BuildContext context) {
    // Build your UI using the imagePosts list
    return ListView(
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
                  decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(myImage),
                        fit: BoxFit.cover,
                      )),
                  child: rimage != null
                      ? Image.file(
                          File(rimage),
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
                onTap: () {
                  buildFab(1, context);
                },
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
                style: TextStyle(color: Colors.black, fontFamily: 'Metropolis'),
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
                        MaterialPageRoute(
                        builder: (context) =>  EditPage(
                          nameController: TextEditingController(),
                          userImage: myImage,
                          name: myName,
                          date_of_birth: date_of_birth,
                          phoneNumber: phoneNumber!,
                          selectedHobbiesText: selectedHobbiesText,
                          occupation: occupation!,
                          bio: myBio,
                          occupationController: TextEditingController(),
                          dateOfBirthController: TextEditingController(),
                          phoneNumberController: TextEditingController(),
                          bioController: TextEditingController(),
                      ),
                    ));                  },
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppSettings(privacySwitchValue: privacySwitchValue),
                        ));
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
                                    color:
                                        _persposts ? Colors.black : Colors.grey,
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
                                    color:
                                        _persposts ? Colors.grey : Colors.black,
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
              _persposts
                  ? Expanded(child: ProfilePostsStream())
                  : Expanded(child: Update()),
            ],
          ),
        )
      ],
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
                color: Colors.orange.shade600,
                size: 25.0,
              ),
              title: Text('Bronze'),
              trailing: Text('2,500 tshs'),
              subtitle: Text('500 followers'),
              onTap: () {
                Navigator.pop(context);
                buildPayments('value', context);
              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.circle_fill,
                color: Colors.grey,
                size: 25.0,
              ),
              title: Text('Silver'),
              trailing: Text('5,000 tshs'),
              subtitle: Text('1,100 followers'),
              onTap: () async {
                Navigator.pop(context);
                buildPayments('value', context);
              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.circle_fill,
                color: Colors.yellowAccent.shade400,
                size: 25.0,
              ),
              title: Text('Gold'),
              trailing: Text('10,000 tshs'),
              subtitle: Text('2,300 followers'),
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

class Update extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BangUpdateProfileProvider(),
      child: _UpdatePostsStreamContent(),
    );
  }
}

class _UpdatePostsStreamContent extends StatefulWidget {
  @override
  _UpdatePostsStreamContentState createState() =>
      _UpdatePostsStreamContentState();
}

class _UpdatePostsStreamContentState extends State<_UpdatePostsStreamContent> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final updateProvider =
        Provider.of<BangUpdateProfileProvider>(context, listen: false);
    updateProvider.getMyUpdate();
    _scrollController.addListener(_scrollListener);

  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // User has reached the end, load more data here
      final updateProvider = Provider.of<BangUpdateProfileProvider>(context, listen: false);
      updateProvider.getMyUpdate(); // Trigger loading of the next page

    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BangUpdateProfileProvider>(
        builder: (context, provider, child) {
          if (provider.updates.isEmpty && provider.isLoading == false  ) {
            return Center(child: Text('No Posts Available'));
          }
          else if(provider.isLoading == false && provider.updates.isNotEmpty) {
            return SingleChildScrollView(
              controller: _scrollController,
              child: GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  children: [
                    for (var i = 0; i < provider.updates.length; i++)
                      if(provider.updates[i].type == 'image')
                        ...[
                          Container(
                            height: 250,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: InkWell(
                                onTap: () {
                                  print('pressed');
                                },
                                child: CachedNetworkImage(
                                  imageUrl: provider.updates[i].filename,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ), ]
                      else if(provider.updates[i].type == 'video') ...[
                        Container(
                          height: 250,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                                onTap: () {
                                  print('pressed');
                                },
                                child:VideoRect(message:provider.updates[i].filename)

                            ),
                          ),
                        )
                      ]
                  ]
              ),

            );
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
      }
    );
  }
}


class ProfilePostsStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(),
      child: _ProfilePostsStreamContent(),
    );
  }
}

class _ProfilePostsStreamContent extends StatefulWidget {
  @override
  _ProfilePostsStreamContentState createState() =>
      _ProfilePostsStreamContentState();
}

class _ProfilePostsStreamContentState extends State<_ProfilePostsStreamContent> {

  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    final providerPost = Provider.of<ProfileProvider>(context, listen: false);
    providerPost.getMyPosts();
    _scrollController.addListener(_scrollListener);
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // User has reached the end, load more data here
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.getMyPosts();
    }
  }
  @override
  Widget build(BuildContext context) {
    // Use the ProfileProvider here to build your UI based on the fetched posts
      return Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            if(provider.posts.isEmpty && provider.isLoading == false){
              return Center(child: Text('No Posts Available'));
            }
            else if ( provider.isLoading == false && provider.posts.isNotEmpty){
              return SingleChildScrollView(
                controller: _scrollController,
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
                      for (var i = 0; i < provider.posts.length; i++)
                        if(provider.posts[i].type == 'image' && provider.posts[i].challengeImgUrl=='' && provider.posts[i].pinned == 0)
                          ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => POstView(
                                    provider.posts[i].name!,
                                    provider.posts[i].caption!,
                                    provider.posts[i].imageUrl!,
                                    provider.posts[i].challengeImgUrl!,
                                    provider.posts[i].imgWidth!,
                                    provider.posts[i].imgHeight!,
                                    provider.posts[i].postId!,
                                    provider.posts[i].commentCount!,
                                    provider.posts[i].userId!,
                                    provider.posts[i].isLikedA,
                                    provider.posts[i].likeCountA,
                                    provider.posts[i].type!,
                                    provider.posts[i].followerCount!,
                                    provider.posts[i].createdAt!,
                                    provider.posts[i].userImage!,
                                    provider.posts[i].pinned!,
                                    provider,
                                  )));
                                },

                                child:
                                CachedNetworkImage(
                                  imageUrl: provider.posts[i].imageUrl!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ), ]
                        else if(provider.posts[i].type == 'image' && provider.posts[i].challengeImgUrl=="" && provider.posts[i].pinned == 1) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => POstView(
                                  provider.posts[i].name!,
                                  provider.posts[i].caption!,
                                  provider.posts[i].imageUrl!,
                                  provider.posts[i].challengeImgUrl!,
                                  provider.posts[i].imgWidth!,
                                  provider.posts[i].imgHeight!,
                                  provider.posts[i].postId!,
                                  provider.posts[i].commentCount!,
                                  provider.posts[i].userId!,
                                  provider.posts[i].isLikedA,
                                  provider.posts[i].likeCountA,
                                  provider.posts[i].type!,
                                  provider.posts[i].followerCount!,
                                  provider.posts[i].createdAt!,
                                  provider.posts[i].userImage!,
                                  provider.posts[i].pinned!,
                                  provider,
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
                        else if(provider.posts[i].type =='image' &&provider.posts[i].challengeImgUrl != ''&& provider.posts[i].pinned == 0)...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => POstChallengeView(
                                        provider.posts[i].name!,
                                        provider.posts[i].caption!,
                                        provider.posts[i].imageUrl!,
                                        provider.posts[i].challengeImgUrl!,
                                        provider.posts[i].imgWidth!,
                                        provider.posts[i].imgHeight!,
                                        provider.posts[i].postId!,
                                        provider.posts[i].commentCount!,
                                        provider.posts[i].userId!,
                                        provider.posts[i].isLikedA,
                                        provider.posts[i].likeCountA,
                                        provider.posts[i].type!,
                                        provider.posts[i].followerCount!,
                                        provider.posts[i].createdAt!,
                                        provider.posts[i].userImage!,
                                        provider.posts[i].pinned!
                                    )));
                                  },

                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CachedNetworkImage(
                                          imageUrl: provider.posts[i].imageUrl!,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: CachedNetworkImage(
                                          imageUrl: provider.posts[i].challengeImgUrl!,
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          ]
                          else if(provider.posts[i].type == 'video'&& provider.posts[i].challengeImgUrl=="")...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => POstView(
                                        provider.posts[i].name!,
                                        provider.posts[i].caption!,
                                        provider.posts[i].imageUrl!,
                                        provider.posts[i].challengeImgUrl!,
                                        provider.posts[i].imgWidth!,
                                        provider.posts[i].imgHeight!,
                                        provider.posts[i].postId!,
                                        provider.posts[i].commentCount!,
                                        provider.posts[i].userId!,
                                        provider.posts[i].isLikedA,
                                        provider.posts[i].likeCountA,
                                        provider.posts[i].type!,
                                        provider.posts[i].followerCount!,
                                        provider.posts[i].createdAt!,
                                        provider.posts[i].userImage!,
                                        provider.posts[i].pinned!,
                                        provider
                                    )));
                                  },
                                  child: VideoRect(message:provider.posts[i].imageUrl),
                                ),
                              ),
                            ]
                            else if(provider.posts[i].type == 'video' && provider.posts[i].challengeImgUrl!="")...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => POstVideoChallengeView(
                                          provider.posts[i].name!,
                                          provider.posts[i].caption!,
                                          provider.posts[i].imageUrl!,
                                          provider.posts[i].challengeImgUrl!,
                                          provider.posts[i].imgWidth!,
                                          provider.posts[i].imgHeight!,
                                          provider.posts[i].postId!,
                                          provider.posts[i].commentCount!,
                                          provider.posts[i].userId!,
                                          provider.posts[i].isLikedA,
                                          provider.posts[i].likeCountA,
                                          provider.posts[i].type!,
                                          provider.posts[i].followerCount!,
                                          provider.posts[i].createdAt!,
                                          provider.posts[i].userImage!,
                                          provider.posts[i].pinned!,

                                        )));
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: VideoRect(message:provider.posts[i].imageUrl),
                                          ),
                                          Expanded(
                                            child: VideoRect(message:provider.posts[i].challengeImgUrl),
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              ]
                    ]
                ),
              );
            }
            else {
              return Center(child: CircularProgressIndicator());
            }

         }
      );


  }
}
