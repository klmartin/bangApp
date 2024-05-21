import 'dart:convert';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/screens/Profile/profilelist_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/services/service.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:bangapp/models/image_post.dart';
import 'package:bangapp/screens/Posts/postView_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../message/screens/messages/message_screen.dart';
import '../../providers/Profile_Provider.dart';
import '../../providers/bangUpdate_profile_provider.dart';
import '../../providers/follower_provider.dart';
import '../../providers/friends_provider.dart';
import '../../providers/message_payment_provider.dart';
import '../../providers/subscription_payment_provider.dart';
import '../../providers/user_profile_data_provider.dart';
import '../../widgets/friends_sheet.dart';
import '../../widgets/video_rect.dart';
import '../Explore/bang_update_view.dart';
import '../Posts/post_challenge_view.dart';
import '../Posts/post_video_challenge_view.dart';
import 'package:bangapp/loaders/profile_posts_skeleton.dart';
import 'package:bangapp/loaders/profile_updates_skeleton.dart';

List<dynamic> followinglist = [];
bool _persposts = true;
List<dynamic> followlist = [];

class UserProfile extends StatefulWidget {
  final userid;
  UserProfile({required this.userid});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  ScrollController? _scrollController;
  bool _isLoading = false;

  final int _numberOfPostsPerRequest = 20;
  int _pageNumber = 1;
  List<ImagePost> allImagePosts = [];
  late MessagePaymentProvider messagePaymentProvider;
  late UserProfileDataProvider userProfileDataProvider;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    userProfileDataProvider =
        Provider.of<UserProfileDataProvider>(context, listen: false);
    userProfileDataProvider.getUserInfo(widget.userid);
    messagePaymentProvider =
        Provider.of<MessagePaymentProvider>(context, listen: false);
    _scrollController = ScrollController();
    _scrollController?.addListener(_scrollListener);
    messagePaymentProvider.addListener(() {
      if (messagePaymentProvider.payed == true) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MessagesScreen(
              widget.userid!,
              userProfileDataProvider.userData['name'],
              userProfileDataProvider.userData['user_image_url'],
              userProfileDataProvider.userData['public'],
              widget.userid,
              userProfileDataProvider.userData['price']);
        }));
        userProfileDataProvider.setUserRequestStatus(false);
      }
    });
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.pop(context);
    return true;
  }

  void _scrollListener() {
    if (_scrollController!.position.pixels >=
        _scrollController!.position.maxScrollExtent - 200) {
      _pageNumber++;
      _loadMorePosts();
    }
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
      allImagePosts.addAll(newPosts.map((post) {
        return ImagePost(
          name: post['user']['name'],
          caption: post['body'] ?? "",
          imageUrl: post['image'],
          challengeImgUrl: post['challenge_img'] ?? "",
          imgWidth: post['width'],
          imgHeight: post['height'],
          postId: post['id'],
          commentCount: post['commentCount'],
          userId: post['user']['id'],
          isLikedA: post['isLikedA'],
          likeCountA: post['like_count_A'],
          type: post['type'],
          followerCount: post['followerCount'],
          createdAt: post['created_at'],
          userImage: post['user_image_url'],
          pinned: post['pinned'],
          isLikedB: post['isLikedA'],
          likeCountB: post['like_count_B'],
          postViews: post['post_views_count'],
        );
      }));
    });
  }

  Future<List<dynamic>> getMyPosts(int pageNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final viewerId = prefs.getInt('user_id').toString();
    var response = await http.get(Uri.parse(
        "$baseUrl/getMyPosts?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest&user_id=${widget.userid}&viewer_id=$viewerId"));
    print(response.body);
    var data = json.decode(response.body);
    return data['data']['data'];
  }

  @override
  Widget build(BuildContext context) {

    final friendProvider = Provider.of<FriendProvider>(context, listen: false);
    final userProfileDataProvider =
        Provider.of<UserProfileDataProvider>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () async {
              Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFF40BF5),
                    Color(0xFFBF46BE),
                    Color(0xFFF40BF5)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(Icons.navigate_before_outlined, size: 30),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                if (userProfileDataProvider.userData['public']) {
                  buildMessagePayment(context,
                      userProfileDataProvider.userData['price'], int.parse(widget.userid));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MessagesScreen(
                        widget.userid!,
                        userProfileDataProvider.userData['name'],
                        userProfileDataProvider.userData['user_image_url'],
                        userProfileDataProvider.userData['public'],
                        widget.userid,
                        userProfileDataProvider.userData['price']);
                  }));
                }
              },
              child: Container(
                  margin: EdgeInsets.only(top: 14),
                  height: 40,
                  width: 25,
                  child: Image.asset('assets/images/chatmessage.png')),
            ),
            SizedBox(width: 20)
          ],
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: Padding(
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
                      decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                userProfileDataProvider
                                        .userData['user_image_url'] ??
                                    profileUrl),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          userProfileDataProvider.userData['postCount']
                              .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: 'Metropolis'),
                        ),
                      ),
                      Text(
                        'Posts',
                        style:
                            TextStyle(fontFamily: 'Metropolis', fontSize: 12),
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
                          userProfileDataProvider.userData['followerCount']
                              .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: 'Metropolis'),
                        ),
                      ),
                      Text(
                        'Followers',
                        style:
                            TextStyle(fontFamily: 'Metropolis', fontSize: 12),
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
                  GestureDetector(
                    onTap: () async {
                      FriendsModal.showFriendsModal(context, widget.userid);
                      await Provider.of<FriendProvider>(context, listen: false)
                          .getFriends(userId: widget.userid);
                    },
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            userProfileDataProvider.userData['friendsCount']
                                .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'Metropolis'),
                          ),
                        ),
                        Text(
                          'Friends',
                          style:
                              TextStyle(fontFamily: 'Metropolis', fontSize: 12),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  userProfileDataProvider.userData['name'] ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Metropolis',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                    // constraints: BoxConstraints(maxWidth: ),
                    child: Text(userProfileDataProvider.userData['bio'] ?? "")),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: userProfileDataProvider.userData['subscribe'] == 1
                        ? OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              //follow or unfollow
                              buildSubscriptionPayment(
                                  context,
                                  userProfileDataProvider
                                      .userData['subscriptionPrice'],
                                  widget.userid);
                            },
                            child: Text(
                              'Subscribe',
                              style: TextStyle(color: Colors.black),
                            ))
                        : OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.grey.shade300,
                              ),
                            ),
                            onPressed: () async {
                              showSubscriptionInfo(
                                  context,
                                  userProfileDataProvider
                                      .userData['subscriptionDays']);
                              //follow or unfollow
                            },
                            child: Text(
                              'Subscribed',
                              style: TextStyle(color: Colors.black),
                            )),
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: Container(
                    child: OutlinedButton(
                        onPressed: () async {
                          userProfileDataProvider.userData['isFriendRequest'] =
                              true;
                          userProfileDataProvider.setUserRequestStatus(true);
                          await friendProvider.requestFriendship(widget.userid);
                          if (friendProvider.addingFriend == true) {
                            Fluttertoast.showToast(
                              msg: friendProvider.requestMessage,
                              toastLength:
                                  Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
                              gravity: ToastGravity.CENTER, // Toast position
                              timeInSecForIosWeb:
                                  1, // Time duration for iOS and web
                              backgroundColor: Colors.grey[600],
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        child: Text(
                          userProfileDataProvider.userFriendStatus,
                          style: TextStyle(color: Colors.black),
                        )),
                  )),
                ],
              ),
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
                                        color: _persposts
                                            ? Colors.black
                                            : Colors.grey,
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
                                        color: _persposts
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    _persposts
                        ? Expanded(
                            child: ProfilePostsStream(
                            userid: widget.userid.toString(),
                            subscribe:
                                userProfileDataProvider.userData['subscribe'] ==
                                        1
                                    ? true
                                    : false,
                            username:
                                userProfileDataProvider.userData['name'] ?? "",
                          ))
                        : Expanded(
                            child: Update(userid: widget.userid.toString())),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class Update extends StatelessWidget {
  String userid;
  Update({required this.userid});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BangUpdateProfileProvider(),
      child: _UpdatePostsStreamContent(
        userid: userid,
      ),
    );
  }
}

class _UpdatePostsStreamContent extends StatefulWidget {
  String userid;
  _UpdatePostsStreamContent({required this.userid});

  @override
  _UpdatePostsStreamContentState createState() =>
      _UpdatePostsStreamContentState();
}

class _UpdatePostsStreamContentState extends State<_UpdatePostsStreamContent> {
  ScrollController _scrollController = ScrollController();
  int _pageNumber = 1;

  @override
  void initState() {
    super.initState();
    final updateProvider =
        Provider.of<BangUpdateProfileProvider>(context, listen: false);
    updateProvider.getUserUpdate(widget.userid);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final updateProvider =
          Provider.of<BangUpdateProfileProvider>(context, listen: false);
      if (updateProvider.isLoading != true) {
        _pageNumber++;
        updateProvider.loadMoreUserUpdates(
            widget.userid, _pageNumber); // Trigger loading of the next page
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BangUpdateProfileProvider>(
        builder: (context, provider, child) {
      if (provider.isLoading == false && provider.updates.isEmpty) {
        return Center(child: Text('No Posts Available'));
      } else if (provider.isLoading == false && provider.updates.isNotEmpty) {
        return SingleChildScrollView(
          controller: _scrollController,
          child: GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              children: [
                for (var i = 0; i < provider.updates.length; i++)
                  if (provider.updates[i].type == 'image') ...[
                    Container(
                      height: 250,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateView(
                                        provider.updates[i].postId,
                                        provider.updates[i].type,
                                        provider.updates[i].filename,
                                        provider.updates[i].likeCount,
                                        provider.updates[i].isLiked,
                                        provider.updates[i].commentCount,
                                        provider.updates[i].userImage,
                                        provider.updates[i].userName,
                                        provider.updates[i].caption,
                                        provider.updates[i].aspectRatio,
                                        provider.updates[i].thumbnailUrl,
                                        provider.updates[i].cacheUrl,
                                        provider)));
                          },
                          child: CachedNetworkImage(
                            imageUrl: provider.updates[i].filename,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ] else if (provider.updates[i].type == 'video') ...[
                    Container(
                      height: 250,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateView(
                                          provider.updates[i].postId,
                                          provider.updates[i].type,
                                          provider.updates[i].filename,
                                          provider.updates[i].likeCount,
                                          provider.updates[i].isLiked,
                                          provider.updates[i].commentCount,
                                          provider.updates[i].userImage,
                                          provider.updates[i].userName,
                                          provider.updates[i].caption,
                                          provider.updates[i].aspectRatio,
                                          provider.updates[i].thumbnailUrl,
                                          provider.updates[i].cacheUrl,
                                          provider)));
                            },
                            child: CachedNetworkImage(
                              imageUrl: provider.updates[i].thumbnailUrl,
                              fit: BoxFit.cover,
                            )),
                      ),
                    )
                  ]
              ]),
        );
      } else {
        return ProfileUpdateSkeleton();
      }
    });
  }
}

class ProfilePostsStream extends StatelessWidget {
  @override
  String userid;
  bool subscribe;
  String username;
  ProfilePostsStream(
      {required this.userid, required this.subscribe, required this.username});
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(),
      child: _ProfilePostsStreamContent(
        userid: userid,
        subscribe: subscribe,
        username: username,
      ),
    );
  }
}

class _ProfilePostsStreamContent extends StatefulWidget {
  String userid;
  bool subscribe;
  String username;
  _ProfilePostsStreamContent(
      {required this.userid, required this.subscribe, required this.username});
  @override
  _ProfilePostsStreamContentState createState() =>
      _ProfilePostsStreamContentState();
}

class _ProfilePostsStreamContentState
    extends State<_ProfilePostsStreamContent> {
  ScrollController _scrollController = ScrollController();
  int _pageNumber = 1;
  late SubscriptionPaymentProvider subscriptionPaymentProvider;

  @override
  void initState() {
    super.initState();
    final providerPost = Provider.of<ProfileProvider>(context, listen: false);
    providerPost.getUserPost(widget.userid, _pageNumber);
    _scrollController.addListener(_scrollListener);
    subscriptionPaymentProvider =
        Provider.of<SubscriptionPaymentProvider>(context, listen: false);

    subscriptionPaymentProvider.addListener(() {
      if (subscriptionPaymentProvider.payed == true) {
        setState(() {
          widget.subscribe = false;
        });
        // subscriptionPaymentProvider.deletePinnedById(paymentProvider.payedPost);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      if (profileProvider.isLoading != true) {
        _pageNumber++;
        profileProvider.loadMoreUserData(widget.userid, _pageNumber);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileDataProvider =
    Provider.of<UserProfileDataProvider>(context, listen: true);
    return Consumer<ProfileProvider>(builder: (context, provider, child) {
      if (provider.posts.isEmpty && provider.isLoading == false) {
        return Center(child: Text('No Posts Available'));
      } else if (widget.subscribe == true) {
        return GestureDetector(
          onTap: (){   buildSubscriptionPayment(
              context,
              userProfileDataProvider
                  .userData['subscriptionPrice'],
              int.parse(widget.userid)); },
          child: Center(
              child: Text('Subscribe to View ${widget.username} Posts',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
        );
      } else if (provider.isLoading == false && provider.posts.isNotEmpty) {
        return SingleChildScrollView(
          controller: _scrollController,
          child: GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              children: [
                for (var i = 0; i < provider.posts.length; i++)
                  if (provider.posts[i].type == 'image' &&
                      provider.posts[i].challengeImgUrl == '' &&
                      provider.posts[i].pinned == 0) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => POstView(
                                        provider.posts[i].name!,
                                        provider.posts[i].caption!,
                                        provider.posts[i].imageUrl!,
                                        provider.posts[i].challengeImgUrl!,
                                        provider.posts[i].imgWidth!,
                                        provider.posts[i].imgHeight!,
                                        provider.posts[i].postId!,
                                        provider.posts[i].commentCount,
                                        provider.posts[i].userId!,
                                        provider.posts[i].isLikedA,
                                        provider.posts[i].likeCountA,
                                        provider.posts[i].type!,
                                        provider.posts[i].followerCount!,
                                        provider.posts[i].createdAt!,
                                        provider.posts[i].userImage!,
                                        provider.posts[i].pinned!,
                                        provider.posts[i].cacheUrl,
                                        provider.posts[i].thumbnailUrl,
                                        provider.posts[i].aspectRatio,
                                        provider.posts[i].price,
                                        provider.posts[i].postViews,
                                        provider,
                                      )));
                        },
                        child: CachedNetworkImage(
                          imageUrl: provider.posts[i].imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ] else if (provider.posts[i].type == 'image' &&
                      provider.posts[i].challengeImgUrl == "" &&
                      provider.posts[i].pinned == 1) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => POstView(
                                        provider.posts[i].name!,
                                        provider.posts[i].caption!,
                                        provider.posts[i].imageUrl!,
                                        provider.posts[i].challengeImgUrl!,
                                        provider.posts[i].imgWidth!,
                                        provider.posts[i].imgHeight!,
                                        provider.posts[i].postId!,
                                        provider.posts[i].commentCount,
                                        provider.posts[i].userId!,
                                        provider.posts[i].isLikedA,
                                        provider.posts[i].likeCountA,
                                        provider.posts[i].type!,
                                        provider.posts[i].followerCount!,
                                        provider.posts[i].createdAt!,
                                        provider.posts[i].userImage!,
                                        provider.posts[i].pinned!,
                                        provider.posts[i].cacheUrl,
                                        provider.posts[i].thumbnailUrl,
                                        provider.posts[i].aspectRatio,
                                        provider.posts[i].price,
                                        provider.posts[i].postViews,
                                        provider,
                                      )));
                        },
                        child: Image.network(
                          pinnedUrl,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ] else if (provider.posts[i].type == 'image' &&
                      provider.posts[i].challengeImgUrl != '' &&
                      provider.posts[i].pinned == 0) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => POstChallengeView(
                                  provider.posts[i].name!,
                                  provider.posts[i].caption!,
                                  provider.posts[i].imageUrl!,
                                  provider.posts[i].challengeImgUrl!,
                                  provider.posts[i].imgWidth!,
                                  provider.posts[i].imgHeight!,
                                  provider.posts[i].postId!,
                                  provider.posts[i].commentCount,
                                  provider.posts[i].userId!,
                                  provider.posts[i].isLikedA,
                                  provider.posts[i].likeCountA,
                                  provider.posts[i].type!,
                                  provider.posts[i].followerCount!,
                                  provider.posts[i].createdAt!,
                                  provider.posts[i].userImage!,
                                  provider.posts[i].pinned!,
                                  provider.posts[i].isLikedA,
                                  provider.posts[i].isLikedB,
                                  provider.posts[i].likeCountA,
                                  provider.posts[i].likeCountB,
                                  provider.posts[i].postViews,
                                  provider,
                                ),
                              ),
                            );
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
                          )),
                    ),
                  ] else if (provider.posts[i].type == 'video' &&
                      provider.posts[i].challengeImgUrl == "") ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => POstView(
                                      provider.posts[i].name!,
                                      provider.posts[i].caption!,
                                      provider.posts[i].imageUrl!,
                                      provider.posts[i].challengeImgUrl!,
                                      provider.posts[i].imgWidth!,
                                      provider.posts[i].imgHeight!,
                                      provider.posts[i].postId!,
                                      provider.posts[i].commentCount,
                                      provider.posts[i].userId!,
                                      provider.posts[i].isLikedA,
                                      provider.posts[i].likeCountA,
                                      provider.posts[i].type!,
                                      provider.posts[i].followerCount!,
                                      provider.posts[i].createdAt!,
                                      provider.posts[i].userImage!,
                                      provider.posts[i].pinned!,
                                      provider.posts[i].cacheUrl,
                                      provider.posts[i].thumbnailUrl,
                                      provider.posts[i].aspectRatio,
                                      provider.posts[i].price,
                                      provider.posts[i].postViews,
                                      provider)));
                        },
                        child: CachedNetworkImage(
                          imageUrl: provider.posts[i].pinned == 1
                              ? pinnedUrl
                              : provider.posts[i].thumbnailUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ] else if (provider.posts[i].type == 'video' &&
                      provider.posts[i].challengeImgUrl != "") ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        POstVideoChallengeView(
                                          provider.posts[i].name!,
                                          provider.posts[i].caption!,
                                          provider.posts[i].imageUrl!,
                                          provider.posts[i].challengeImgUrl!,
                                          provider.posts[i].imgWidth!,
                                          provider.posts[i].imgHeight!,
                                          provider.posts[i].postId!,
                                          provider.posts[i].commentCount,
                                          provider.posts[i].userId!,
                                          provider.posts[i].isLikedA,
                                          provider.posts[i].likeCountA,
                                          provider.posts[i].type!,
                                          provider.posts[i].followerCount!,
                                          provider.posts[i].createdAt!,
                                          provider.posts[i].userImage!,
                                          provider.posts[i].pinned!,
                                          provider.posts[i].postViews,
                                        )));
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: VideoRect(
                                    message: provider.posts[i].imageUrl),
                              ),
                              Expanded(
                                child: VideoRect(
                                    message: provider.posts[i].challengeImgUrl),
                              ),
                            ],
                          )),
                    ),
                  ]
              ]),
        );
      } else {
        return ProfilePostSkeleton();
      }
    });
  }
}
