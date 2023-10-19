import 'dart:convert';
import 'package:bangapp/screens/Profile/user_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bangapp/screens/Profile/edit_profile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:bangapp/screens/Story/storyview.dart';
import 'package:bangapp/screens/settings/settings.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/userprovider.dart';
import 'package:bangapp/services/fetch_post.dart';
import 'profile_upload.dart';
import 'package:bangapp/constants/urls.dart';

late bool _persposts ;

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
  }

  late final GoogleSignInAccount user;

  @override
  Widget build(BuildContext context) {
    final userData=  Provider.of<UserProvider>(context,listen:false);
    print(userData.myUser.id);
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
                                image: CachedNetworkImageProvider('$profileUrl/bang_logo.jpg') ,
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
                  onTap: () {
                    openFilterDialog();
                  },
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
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => EditPage(user: user)));
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
  List<Hobby>? selectedHobbyList;
  List<Hobby> hobbyList = [];

  String selectedHobbiesText = "";
  List<int> selectedHobbyIds = [];

  loadHobbies() async {
    try {
      hobbyList = await fetchHobbies();
      return hobbyList;
    } catch (e) {
      // Handle error, if any
    }
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
  void openFilterDialog() async {
    await FilterListDialog.display<Hobby>(
      context,
      listData: await loadHobbies()!, // Use hobbyList as the data source
      selectedListData: selectedHobbyList,
      choiceChipLabel: (hobby) => hobby!.name, // Access the name property of Hobby
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (hobby, query) {
        return hobby.name!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedHobbyList = List.from(list!);
        });
        Navigator.pop(context);
        buildFab('value', context);
      },
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
          // Navigator.push(
              // context, MaterialPageRoute(builder: (context) => POstView(url)));
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
