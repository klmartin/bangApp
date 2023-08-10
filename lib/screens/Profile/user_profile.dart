import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bangapp/screens/Chat/chat_model.dart';
// import 'package:bangapp/edit_profile.dart';
import 'package:bangapp/services/fetch_post.dart';
import 'package:bangapp/screens/Posts/postView_model.dart';

List<dynamic> followinglist = [];
late int cufollowing;
bool _persposts = true;
late int followers;
List<dynamic> followlist = [];


class UserProfile extends StatefulWidget {
  final posts;
  final descr;
  final photoUrl;
  final name;
  final userid;
  String followState = 'Follow';
  int followers;
  int following;

  UserProfile(
      {required this.posts,
      required this.photoUrl,
      required this.descr,
      required this.name,
      required this.followers,
      required this.following,
      required this.userid});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(widget.photoUrl),
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      '${widget.posts}',
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
                      '${widget.followers}',
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
                      '${widget.following}',
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
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.name.toUpperCase(),
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
                child: Text('${widget.descr}')),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                    ),
                    onPressed: () async { //follow or unfollow

                    },
                    child: Text('Unfollow Follow',
                      style: TextStyle(
                          color:Colors.white),
                    )),
              )),
              SizedBox(width: 10),
              Expanded(
                  child: Container(
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PmScreen(selectedUser: widget.userid, name: '', profileUrl: '',);
                      }));
                    },
                    child: Text(
                      'Message',
                      style: TextStyle(color: Colors.black),
                    )),
              )),
            ],
          ),
          ProfilePosts(
            userid: widget.userid,
          ),
        ],
      ),
    );
  }
}
class ProfilePosts extends StatefulWidget {
  final int ? userid;
  ProfilePosts({ this.userid});
  @override
  _ProfilePostsState createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                                color: _persposts ? Colors.black : Colors.grey,
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
                              color: _persposts ? Colors.black : Colors.grey,
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
                                color: _persposts ? Colors.grey : Colors.black,
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
                              color: _persposts ? Colors.grey : Colors.black,
                            ),
                          ),
                        ),
                      )),
                  // child: IonButton(
                  //     onPressed: () {
                  //       setState(() {
                  //         _persposts = false;
                  //       });
                  //     },
                  //     icon: FaIcon(
                  //       FontAwesomeIcons.solidIdBadge,
                  //     )),
                ),
              ),
            ],
          ),
          _persposts
              ? ProfilePostsStream(userid: widget.userid)
              : Expanded(child: Tagged()),
        ],
      ),
    );
  }
}

class ImagePost extends StatelessWidget {
  final bool isMe = true;
  final caption;
  final name;
  final imgurl;
  final challengeImgUrl;
  final imgWidth;
  final imgHeight;
  final postId;
  final commentCount;
  final userId;
  final isLiked;
  final likeCount;
  final type;
  ImagePost({this.name,this.caption, this.imgurl, this.challengeImgUrl, this.imgWidth, this.imgHeight, this.postId, this.commentCount, this.userId, this.isLiked, this.likeCount, this.type});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => POstView(name,caption,imgurl,challengeImgUrl,imgWidth,imgHeight,postId,commentCount,userId,isLiked,likeCount,type)));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.red.shade100,
          image: DecorationImage(
              image: CachedNetworkImageProvider(imgurl), fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class ProfilePostsStream extends StatelessWidget {
  final userid;
  ProfilePostsStream({required this.userid});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:FetchPosts().getMyPosts(userid),
      builder: (context, snapshot) {
        List<ImagePost> ImagePosts = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlue,
            ),
          );
        }
        final List<dynamic> posts = snapshot.data! as List<dynamic>;
        for (var post in posts!) {
          if (post['userid'] == userid) {
            final image = post['image'];
            final imagePost = ImagePost(
              caption:post['body'],
              name:post['user']['name'],
              imgurl:post['image'],
              challengeImgUrl:post['challenge_img'],
              imgWidth:post['width'],
              imgHeight:post['height'],
              postId:post['id'],
              commentCount:post['commentCount'],
              userId:post['user_id'],
              isLiked:post['isFavorited']==0 ? false : true,
              likeCount:post['likes'] != null && post['likes'].isNotEmpty ? post['likes'][0]['like_count'] : 0,
              type:post['type'],
            );
            ImagePosts.add(imagePost);
          }
        }
        return Expanded(
          child: ImagePosts.isEmpty
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
                  child: GridView.count(
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    crossAxisCount: 3,
                    children: ImagePosts,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                  ),
                ),
        );
      },
    );
  }
}

class Tagged extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'No photos yet',
          style: TextStyle(fontFamily: 'Metropolis'),
        )
      ],
    );
  }
}
