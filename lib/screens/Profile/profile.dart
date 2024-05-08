import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bangapp/screens/Profile/edit_my_profile.dart';
import 'package:bangapp/screens/settings/settings.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../models/hobby.dart';
import '../../providers/Profile_Provider.dart';
import '../../providers/bangUpdate_profile_provider.dart';
import '../../providers/follower_provider.dart';
import '../../providers/friends_provider.dart';
import '../../widgets/followers_sheet.dart';
import '../../widgets/friends_sheet.dart';
import '../../widgets/video_rect.dart';
import '../Explore/bang_update_view.dart';
import '../Posts/postView_model.dart';
import '../Posts/post_challenge_view.dart';
import '../Posts/post_video_challenge_view.dart';
import 'profile_upload.dart';
import 'package:bangapp/models/image_post.dart';
import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/services/service.dart';
import 'package:bangapp/providers/user_provider.dart';
import 'package:bangapp/loaders/profile_header_skeleton.dart';
import 'package:bangapp/loaders/profile_posts_skeleton.dart';
import 'package:bangapp/loaders/profile_updates_skeleton.dart';

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
  int? phoneNumber;
  List<Hobby> hobbies = [];

  DateTime date_of_birth = DateTime.now();
  String selectedHobbiesText = "";
  List<Hobby>? selectedHobbyList;
  List<Hobby> hobbyList = [];
  List<int> selectedHobbyIds = [];
  bool privacySwitchValue = false;
  late FollowerProvider followerProvider;
  late UserProvider userProvider;
  final int _numberOfPostsPerRequest = 20;
  int _pageNumber = 1;
  bool _persposts = true;
  List<ImagePost> allImagePosts = [];

  void fetchHobbies() async {
    setState(() async {
      hobbies = await Service().fetchHobbies();
      print(hobbies![0].name);
      print('first hobby');
    });
  }

  void initState() {
    super.initState();
    fetchHobbies();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    followerProvider = Provider.of<FollowerProvider>(context, listen: false);
    _scrollController = ScrollController();
    _scrollController?.addListener(_scrollListener);
    followerProvider.addListener(() {
      if (followerProvider.payed == true &&
          followerProvider.followersCount > 0) {
        userProvider.addFollowerCount(followerProvider.followersCount);
        followerProvider.resetFollowerCount = 0;
      }
    });
  }

  void _scrollListener() {
    if (!_isLoading && _scrollController!.position.extentAfter < 200.0) {
      _pageNumber++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    if (userProvider.userData.isEmpty) {
      userProvider.fetchUserData();
    }
    return userProvider.userData.isEmpty
        ? ProfileHeaderSkeleton()
        : ListView(
            key: const PageStorageKey<String>('profile'),
            controller: _scrollController,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 20.0, bottom: 10.0),
                    child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  userProvider.userData['user_image_url'] ??
                                      profileUrl),
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
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 8.0),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       openFilterDialog(context);
                  //     },
                  //     child: Container(
                  //       width: 80,
                  //       height: 80,
                  //       child: Transform.translate(
                  //         offset:
                  //             Offset(0, 30), // Adjust the value of 8 as needed
                  //         child: Icon(
                  //           Ionicons.person_add_outline,
                  //           color: Theme.of(context).colorScheme.secondary,
                  //           size: 30,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      userProvider.userData['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Metropolis',
                      ),
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.only(
                  //           right: 8.0), // Adjust as needed
                  //       child: GestureDetector(
                  //         onTap: () {
                  //           openFilterDialog(context);
                  //         },
                  //         child: Text(
                  //           'Buy Followers',
                  //           style: TextStyle(
                  //             fontSize: 14.5,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RichText(
                  overflow: TextOverflow.clip,
                  strutStyle: StrutStyle(fontSize: 12.0),
                  text: TextSpan(
                      style: TextStyle(
                          color: Colors.black, fontFamily: 'Metropolis'),
                      text: userProvider.userData['bio']),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPage(
                                  nameController: TextEditingController(),
                                  userImage:
                                      userProvider.userData['user_image_url'] ?? profileUrl,
                                  name: userProvider.userData['name'] ?? "",
                                  date_of_birth: userProvider.userData['date_of_birth'] != null
                                      ? DateTime.parse(userProvider.userData['date_of_birth'])
                                      : DateTime.parse("2000-01-01"),
                                  phoneNumber:
                                      userProvider.userData['phone_number'] ?? "",
                                  selectedHobbiesText: selectedHobbiesText,
                                  occupation:
                                      userProvider.userData['occupation'] ?? "",
                                  bio: userProvider.userData['bio'] ?? "",
                                  occupationController: TextEditingController(),
                                  dateOfBirthController:
                                      TextEditingController(),
                                  phoneNumberController:
                                      TextEditingController(),
                                  bioController: TextEditingController(),
                                ),
                              ));
                        },
                        child: Text(
                          'Edit profile',
                          style: TextStyle(color: Colors.black),
                        )),
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.only(right: 8),
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppSettings(),
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
                            userProvider.userData['postCount'].toString(),
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
                    GestureDetector(
                      onTap: () async {
                        FollowersModal.showFollowersModal(context);
                        await Provider.of<FollowerProvider>(context,
                                listen: false)
                            .getAllFollowers();
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              // '$followers',
                              userProvider.userData['followerCount'].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: 'Metropolis'),
                            ),
                          ),
                          Text(
                            'Followers',
                            style: TextStyle(
                                fontFamily: 'Metropolis', fontSize: 12),
                          )
                        ],
                      ),
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
                        FriendsModal.showFriendsModal(context,userProvider.userData['id']);
                        await Provider.of<FriendProvider>(context,
                                listen: false)
                            .getFriends();
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              userProvider.userData['friendsCount'].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: 'Metropolis'),
                            ),
                          ),
                          Text(
                            'Friends',
                            style: TextStyle(
                                fontFamily: 'Metropolis', fontSize: 12),
                          )
                        ],
                      ),
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
                        ? Expanded(child: ProfilePostsStream())
                        : Expanded(child: Update()),
                  ],
                ),
              )
            ],
          );
  }

  void updateSelectedHobbiesText() {
    setState(() {
      selectedHobbiesText = selectedHobbyList!
          .map((hobby) => hobby.name!)
          .toList()
          .join(", "); // Concatenate hobby names with a comma and space
      selectedHobbyIds = selectedHobbyList!
          .map((hobby) => hobby.id!) // Access the ID property of the Hobby
          .toList();
    });
  }

  void openFilterDialog(BuildContext context) async {
    selectedHobbyList?.clear();
    selectedHobbyIds?.clear();
    FilterListDialog.display<Hobby>(
      context,
      resetButtonText: "Select/Reset",
      applyButtonText: "Buy",
      backgroundColor: Color(0xFFF40BF5),
      listData: hobbies, // Use hobbyList as the data source
      selectedListData: selectedHobbyList,
      choiceChipLabel: (hobby) =>
          hobby!.name, // Access the name property of Hobby
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (hobby, query) {
        return hobby.name!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          print(selectedHobbyList);
          selectedHobbyList = List.from(list!);
          updateSelectedHobbiesText();
        });
        Navigator.pop(context);
        buildFab(context, selectedHobbiesText, selectedHobbyIds);
      },
    );
  }
}

buildFab(BuildContext context, selectedHobbiesText, selectedHobbyIds) {
  print(selectedHobbiesText);
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
              trailing: Text('2,500 Tshs'),
              subtitle: Text('10 followers'),
              onTap: () {
                Navigator.pop(context);
                buildPayments(
                    selectedHobbiesText, context, 1000, 10, selectedHobbyIds);
              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.circle_fill,
                color: Colors.grey,
                size: 25.0,
              ),
              title: Text('Silver'),
              trailing: Text('5,000 Tshs'),
              subtitle: Text('20 followers'),
              onTap: () async {
                Navigator.pop(context);
                buildPayments(
                    selectedHobbiesText, context, 5000, 20, selectedHobbyIds);
              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.circle_fill,
                color: Colors.yellowAccent.shade400,
                size: 25.0,
              ),
              title: Text('Gold'),
              trailing: Text('10,000 Tshs'),
              subtitle: Text('30 followers'),
              onTap: () {
                print(selectedHobbiesText);
                Navigator.pop(context);
                buildPayments(
                    selectedHobbiesText, context, 10000, 30, selectedHobbyIds);
              },
            ),
          ],
        ),
      );
    },
  );
}

buildPayments(
    selectedHobbiesText, BuildContext context, price, count, selectedHobbyIds) {
  var paymentProvider = Provider.of<FollowerProvider>(context, listen: false);
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    builder: (BuildContext context) {
      return Builder(
        builder: (BuildContext innerContext) {
          return Consumer<FollowerProvider>(
            builder: (context, paymentProvider, _) {
              final userProvider = Provider.of<UserProvider>(innerContext);
              final TextEditingController phoneNumberController =
                  TextEditingController(
                text: userProvider.userData['phone_number'].toString(),
              );

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(
                        child: Text(
                          'Pay $price Tshs for $selectedHobbiesText followers',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone number',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.phone),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                    ),
                    Center(
                      child: paymentProvider.isPaying
                          ? LoadingAnimationWidget.staggeredDotsWave(
                              color: Color(0xFFF40BF5), size: 30)
                          : TextButton(
                              onPressed: () async {
                                paymentProvider.startPaying(
                                    userProvider.userData['phone_number']
                                        .toString(),
                                    price,
                                    count,
                                    'followers',
                                    selectedHobbyIds);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text(
                                'Pay',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  ).then((result) {
    paymentProvider.paymentCanceled = true;
    print(paymentProvider.isPaying);
    print('Modal bottom sheet closed: $result');
  });
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
  ScrollController _scrollUpdateController = ScrollController();
  int _pageNumber = 1;

  @override
  void initState() {
    super.initState();
    final updateProvider =
        Provider.of<BangUpdateProfileProvider>(context, listen: false);
    updateProvider.getMyUpdate();
    _scrollUpdateController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollUpdateController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollUpdateController.position.pixels >=
        _scrollUpdateController.position.maxScrollExtent - 200) {
      print('this is mwisho');
      final updateProvider =
          Provider.of<BangUpdateProfileProvider>(context, listen: false);
      if(updateProvider.isLoading != true){
        _pageNumber++;
        updateProvider.loadMoreUpdates(_pageNumber); // Trigger loading of the next page
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BangUpdateProfileProvider>(
        builder: (context, provider, child) {
      if (provider.updates.isEmpty && provider.isLoading == false) {
        return Center(child: Text('No Posts Available'));
      } else if (provider.isLoading == false && provider.updates.isNotEmpty) {
        return SingleChildScrollView(
          key: const PageStorageKey<String>('update'),
          controller: _scrollUpdateController,
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
                                          provider
                                        )));
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
                                            provider
                                          )));
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

class _ProfilePostsStreamContentState
    extends State<_ProfilePostsStreamContent> {
  ScrollController _scrollController = ScrollController();
  int _pageNumber = 1;

  @override
  void initState() {
    super.initState();
    final providerPost = Provider.of<ProfileProvider>(context, listen: false);
    providerPost.getMyPosts(_pageNumber);
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
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      if(profileProvider.isLoading != true)
      {
        _pageNumber++;
        profileProvider.loadMoreData(_pageNumber);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, provider, child) {
      if (provider.posts.isEmpty && provider.isLoading == false) {
        return Center(child: Text('No Posts Available'));
      } else if (provider.isLoading == false && provider.posts.isNotEmpty) {
        return SingleChildScrollView(
          key: const PageStorageKey<String>('profile'),
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
                                        provider)));
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
                                        provider,
                                      )));
                        },
                        child: CachedNetworkImage(
                          imageUrl: provider.posts[i].pinned == 1
                              ? pinnedUrl
                              : provider.posts[i].thumbnailUrl!,
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
                        child: VideoRect(
                            message: provider.posts[i].pinned == 1
                                ? pinnedUrl
                                : provider.posts[i].thumbnailUrl),
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
                                    message: provider.posts[i].pinned == 1
                                        ? pinnedUrl
                                        : provider.posts[i].thumbnailUrl),
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
