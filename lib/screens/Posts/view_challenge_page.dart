import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import '../../services/animation.dart';
import '../../services/extension.dart';
import 'package:bangapp/services/service.dart';
import '../../widgets/build_media.dart';
import '../../widgets/user_profile.dart';
import '../Comments/commentspage.dart';
import '../Profile/profile.dart';
import '../Widgets/readmore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bangapp/constants/urls.dart';



class ViewChallengePage extends StatefulWidget {
  final int? challengeId;
  ViewChallengePage({
    Key? key,
    this.challengeId,
  }): super(key: key);
  static const id = 'postview';
  @override
  _ViewChallengePageState createState() => _ViewChallengePageState();
}

class _ViewChallengePageState extends State<ViewChallengePage> {
  Future<Map<String, dynamic>> getChallenge() async {
    print(widget.challengeId);
    var response = await http.get(Uri.parse('$baseUrl/getChallenge/${widget.challengeId}'));
    var data = json.decode(response.body);
    return data['data'];
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<Map<String, dynamic>>(
          future: getChallenge(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for data, you can show a loading indicator
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // If there's an error, show an error message
              return Center(
                child: Text('Error fetching data'),
              );
            } else {
              // If data is successfully fetched, pass it to the PostCard widget
              final challengeData = snapshot.data;
              if (challengeData != null) {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: PostCard(
                      challengeData['id'],
                      challengeData['post_id'],
                      challengeData['user_id'],
                      challengeData['user']['name'],
                      challengeData['user']['image'],
                      challengeData['type'],
                      challengeData['challenge_img'],
                      challengeData['body'],
                      challengeData['created_at'],
                      challengeData['width'],
                      challengeData['height'],
                      _scrollController,
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Text('Challenge data is null'),
                );
              }
            }
          },
        ),
      ),
    );
  }
}


class PostCard extends StatefulWidget {
  final id;
  final post_id;
  final user_id;
  final user_name;
  final user_image;
  final type;
  final challenge_img;
  final body;
  final created_at;
  var width;
  var height;
  ScrollController _scrollController = ScrollController();
  PostCard(this.id,this.post_id,this.user_id,this.user_name, this.user_image, this.type, this.challenge_img, this.body,this.created_at,this.width,this.height,this._scrollController);
  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isEditing = false;
  void toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(1, 30, 34, 45),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          createRoute(
                            Profile(
                              id: widget.user_id,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          UserProfile(
                            url: widget.user_image,
                            size: 40,
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.user_name,
                                    style: const TextStyle(
                                      fontFamily: 'EuclidTriangle',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      letterSpacing: 0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 5),

                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                  StringExtension
                                      .displayTimeAgoFromTimestamp(
                                    '2023-04-17 13:51:04',
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
            InkWell(
              onTap: () {
                viewImage(context, widget.challenge_img);
              },
              child: AspectRatio(
                aspectRatio: widget.width / widget.height,
                child: buildMediaWidget(context, widget.challenge_img,widget.type,widget.width,widget.height,0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Service().acceptChallenge(widget.post_id);
                        // Add your logic for accepting here
                      },
                      child: Text('Accept'),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your logic for declining here
                      },
                      child: Text('Decline'),
                    ),
                  ),
                ),
              ],
            ),


            const SizedBox(height: 20),
          ],
        ));
  }
}

class PostCaptionWidget extends StatefulWidget {
  final String? caption;
  final String? name;
  final bool isEditing;

  const PostCaptionWidget({Key? key, this.caption, this.name,required this.isEditing,}) : super(key: key);

  @override
  _PostCaptionWidgetState createState() => _PostCaptionWidgetState();
}

class _PostCaptionWidgetState extends State<PostCaptionWidget> {
  bool _isEditing = false;
  TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _captionController.text = widget.caption ?? '';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing) {
      return TextField(
        controller: _captionController,
        style: Theme.of(context).textTheme.bodyText1!,
        decoration: InputDecoration(
          hintText: 'Type your caption...',
        ),
      );
    }else {
      return ReadMoreText(
        widget.caption ?? "",
        trimLines: 2,
        style: Theme.of(context).textTheme.bodyText1!,
        colorClickableText: Theme.of(context).primaryColor,
        trimMode: TrimMode.line,
        trimCollapsedText: '...Show more',
        trimExpandedText: '...Show less',
        moreStyle: TextStyle(
          fontSize: 15,
          color: Theme.of(context).primaryColor,
        ),
      );
    }
  }
}
