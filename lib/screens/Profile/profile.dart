import 'package:bangapp/screens/Profile/user_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bangapp/screens/Profile/edit_profile.dart';
import 'package:bangapp/screens/Posts/postView_model.dart';
import 'package:bangapp/screens/Story/storyview.dart';
import 'package:bangapp/screens/settings/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/userprovider.dart';
import 'package:bangapp/services/fetch_post.dart';
import 'profile_upload.dart';
final _auth = FirebaseAuth.instance;
late bool _persposts ;

Future<void> myMethod() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? imageUrl = prefs.getString('imageUrl');
  // pass imageUrl to CachedNetworkImageProvider
}
void getProfileData() async {
  // final info = await FetchPosts().getMyPosts();
  // Map data = info.data();
  // followers = data['followers'];
  // following = data['following'];
  // descr = data['descr'];
  // posts = data['posts'];
}

void getCurrentUser() {
  try {
    final user = loggedInUser?.getCurrentUser();
    if (user != null) {

      print(loggedInUser);
    }
  } catch (e) {
    print(e);
  }
}

Future<String?> getUserImage() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? photoURL = prefs.getString('user_image');
    return photoURL;
  } catch (e) {
    print(e);
  }
}

late int posts;
var descr;
late int followers;
late int following;

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
  @override

  void initState() {
    super.initState();
    final userData=  Provider.of<UserProvider>(context,listen:false);
    // getId();
    getCurrentUser();

  }

// void  getId() async {
//     final prefs =  await SharedPreferences.getInstance();
//     ownId = '${prefs.getInt('user_id')}';
// }

  @override
  Widget build(BuildContext context) {
    final userData=  Provider.of<UserProvider>(context,listen:false);
    return Padding(
      padding: const EdgeInsets.all(15.0),
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
                    decoration: rimage != null
                        ? BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(25),
                          )
                        : BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(userData.myUser.profileurl!) ,
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
              SizedBox(width: 280)

            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              userData.myUser.name??"",
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
                  text: descr),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  '76',
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
                    '21',
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
                    '2',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'Metropolis'),
                  ),
                ),
                Text(
                  'Following',
                  style: TextStyle(fontFamily: 'Metropolis', fontSize: 12),
                )
              ],
            ),
            ]),
          ProfilePosts(),
        ],
      ),
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

class ProfilePostsStream extends StatefulWidget {
  final int? id;

  ProfilePostsStream({this.id});

  @override
  _ProfilePostsStreamState createState() => _ProfilePostsStreamState();
}

class _ProfilePostsStreamState extends State<ProfilePostsStream> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FetchPosts().getMyPosts(widget.id),
      builder: (context, snapshot) {
        List<ImagePost> imagePosts = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlue,
            ),
          );
        }
        if (snapshot.hasData) {
          final List<dynamic> posts = snapshot.data! as List<dynamic>;
          for (var post in posts) {
            final image = post['image'];
            final imagePost = ImagePost(
              url: image,
            );
            imagePosts.add(imagePost);
          }
        }


        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: imagePosts,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
          ),
        );
      },
    );
  }
}


class ImagePost extends StatelessWidget {
  final String url;
  final bool isMe = true;

  ImagePost({required this.url});

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => POstView(url)));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.red.shade100,
            image: DecorationImage(
                image: CachedNetworkImageProvider(url), fit: BoxFit.cover),
          ),
        ),
      );
    }
    else {
      return Container();
    }
  }
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
