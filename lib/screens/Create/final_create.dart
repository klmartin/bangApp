import 'dart:async';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';
import 'package:bangapp/services/service.dart';
import '../../components/progressIndicator.dart';
import '../../nav.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import '../../providers/posts_provider.dart';
import '../../providers/video_upload.dart';
import '../Widgets/video_upload.dart';
import 'create_page.dart';

class FinalCreate extends StatefulWidget  {
  static const String id = 'final_posts';
  final Uint8List? editedImage;
  final Uint8List? editedImage2;
  final bool? challengeImg;
  final int? userChallenged;
  final int? postId;
  final String? editedVideo;
  final String? editedVideo2;
  final String? type;
  const FinalCreate({
    Key? key,
    this.editedImage,
    this.userChallenged,
    this.challengeImg = false,
    this.editedImage2,
    this.postId,
    this.editedVideo,
    this.editedVideo2,
    this.type,
  }) : super(key: key);

  @override
  _FinaleCreateState createState() => _FinaleCreateState();
}

class _FinaleCreateState extends State<FinalCreate> with TickerProviderStateMixin {
  Service service = Service();
  VideoPlayerController? videoController;

  bool isLoading2 = false;

  late int myRole = 0;
  void initState() {


    super.initState();
    _initializeSharedPreferences();
  }

  void _initializeSharedPreferences() async {
    var myInfo = await Service().getMyInformation();
    setState(() {
      myRole = myInfo['role_id'] ?? 0;
    });
  }

  var image;
  bool light = true;
  var caption;
  int bangUpdate = 0;
  int pinPost = 0;
  XFile? mediaFile;
  bool isLoading = false;

  Future<String> saveUint8ListAsFile(Uint8List data, String fileName) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/$fileName';
    File file = File(filePath);
    await file.writeAsBytes(data);
    return filePath;
  }

  Future<XFile?> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 88,
      rotate: 180,
    );

    return result;
  }

  Future<File> compressFile(File file) async {
    File compressedFile =
        await FlutterNativeImage.compressImage(file.path, quality: 50);
    return compressedFile;
  }

  @override
  Widget build(BuildContext context) {
    List<Uint8List> images = [];
    List<String> videos = [];
    if (widget.editedImage != null &&
        widget.editedImage2 != null &&
        widget.type == 'image') {
      images.add(widget.editedImage!);
      images.add(widget.editedImage2!);
    }
    if (widget.editedVideo != null && widget.editedVideo2 != null) {
      videos.add(widget.editedVideo!);
      videos.add(widget.editedVideo2!);
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Create(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.pink, Colors.redAccent, Colors.orange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(Icons.arrow_back_rounded, size: 30),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Colors.white,
          actions: [
            Center(
              child: Text(
                'Post',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 1.0),
          children: [
            Container(
                child: Column(children: [
              Row(
                children: [
                  // Display the first image
                  if (widget.editedImage != null && widget.editedImage2 == null)
                    Expanded(
                      child: InkWell(
                        child: Container(
                          width: size.width,
                          height: size.height / 2,
                          child: Image.memory(
                            widget.editedImage!,
                            width: size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  else if (widget.editedImage2 != null &&
                      widget.editedImage != null)
                    Expanded(
                      child: SizedBox(
                        height: size.height / 2, // Specify the desired height
                        child: PageView.builder(
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 190,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.red[200],
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Image.memory(
                                images[index],
                                width: 190.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  else if (widget.editedVideo != null &&
                      widget.editedVideo2 == null &&
                      widget.editedImage2 == null)
                    InkWell(
                      child: Container(
                        width: size.width - 4,
                        height: size.height / 2,
                        child: Chewie(
                          controller: ChewieController(
                            videoPlayerController:
                                VideoPlayerController.network(
                                    widget.editedVideo!),
                            autoPlay: true,
                            looping: false,
                          ),
                        ),
                      ),
                    )
                  else if (widget.editedVideo != null &&
                      widget.editedVideo2 != null)
                    Expanded(
                      child: SizedBox(
                        height: size.height / 2, // Specify the desired height
                        child: PageView.builder(
                          itemCount: videos.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: size.width - 4,
                              height: size.height / 2,
                              child: Chewie(
                                controller: ChewieController(
                                  videoPlayerController:
                                      VideoPlayerController.file(
                                    File(videos[index]),
                                  ),
                                  autoPlay: true,
                                  looping: true,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                ],
              ),
              SizedBox(height: 15.0),
              Text(
                'Caption'.toUpperCase(),
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextFormField(
                initialValue: "",
                decoration: InputDecoration(
                  hintText: 'Write a Caption!',
                  focusedBorder: UnderlineInputBorder(),
                ),
                maxLines: null,
                onChanged: (val) {
                  setState(() {
                    caption = val;
                  });
                },
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    'Pin Post',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Switch(
                    value: pinPost == 1,
                    onChanged: (value) {
                      setState(() {
                        pinPost = value ? 1 : 0;
                      });
                    },
                  ),
                  myRole == 1
                      ? Container(
                          child: Row(
                            children: [
                              Text(
                                'Chemba ya Umbea',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              Switch(
                                value: bangUpdate == 1,
                                onChanged: (value) {
                                  setState(() {
                                    bangUpdate = value ? 1 : 0;
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      : Container()
                ],
              ),
              SizedBox(height: 15),
              // Initially, loading is set to false
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 46.0),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              setState(() {
                                isLoading = true;
                              });
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              try {
                                if (widget.editedImage != null &&
                                    widget.editedImage2 == null &&
                                    widget.challengeImg == false) {
                                  String filePath = await saveUint8ListAsFile(
                                      widget.editedImage!, 'image.jpg');
                                  File compressedImage =
                                      await compressFile(File(filePath));
                                  print("this is compressed");
                                  print(compressedImage);
                                  Map<String, String> body = {
                                    'user_id':
                                        prefs.getInt('user_id').toString(),
                                    'body': caption ?? " ",
                                    'pinned': pinPost == 1 ? '1' : '0',
                                    'type': widget.type!,
                                  };
                                  if (bangUpdate == 1) {
                                    await service.addBangUpdate(body, filePath);
                                  } else {
                                    await service.addImage(
                                        body, compressedImage.path);
                                  }
                                } else if (widget.editedImage != null &&
                                    widget.editedImage2 == null &&
                                    widget.challengeImg == true) {
                                  String filePath = await saveUint8ListAsFile(
                                      widget.editedImage!, 'image.jpg');
                                  Map<String, String> body = {
                                    'user_id':
                                        prefs.getInt('user_id').toString(),
                                    'body': caption ?? "",
                                    'post_id': widget.postId.toString(),
                                    'pinned': pinPost == 1 ? '1' : '0',
                                    'type': widget.type!,
                                  };
                                  await service.addChallenge(
                                      body, filePath, widget.userChallenged!);
                                } else if (widget.editedVideo != null &&
                                    widget.editedVideo2 == null &&
                                    widget.type == 'video') {
                                  // MediaInfo? mediaInfo =
                                  //     await VideoCompress.compressVideo(
                                  //   widget.editedVideo
                                  //       .toString(), // Use the path property
                                  //   quality: VideoQuality.Res640x480Quality,
                                  //   deleteOrigin: true,
                                  // );
                                  Map<String, String> body = {
                                    'user_id':
                                        prefs.getInt('user_id').toString(),
                                    'body': caption ?? "",
                                    'type': widget.type!,
                                    'contentID': '20',
                                    'aspect_ratio': '1.5',
                                    'pinned': pinPost == 1 ? '1' : '0',
                                  };
                                  if (bangUpdate == 1) {
                                    MediaInfo? mediaInfo =
                                        await VideoCompress.compressVideo(
                                      widget.editedVideo
                                          .toString(), // Use the path property
                                      quality: VideoQuality.Res640x480Quality,
                                      deleteOrigin: true,
                                    );
                                    await service.addBangUpdate(
                                        body, mediaInfo?.path ?? '');
                                  } else {
                                    final videoUploadProvider = provider.Provider.of<VideoUploadProvider>(context, listen: false);

                                    videoUploadProvider.startUpload(body, widget.editedVideo);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Nav(initialIndex: 0)),
                                    );
                                  }
                                } else if (widget.editedVideo != null &&
                                    widget.editedVideo2 != null &&
                                    widget.type == 'video') {
                                  String? filePath1 = widget.editedVideo;
                                  Map<String, String> body = {
                                    'user_id':
                                        prefs.getInt('user_id').toString(),
                                    'body': caption ?? "",
                                    'contentID': '20',
                                    'aspect_ratio': '1.5',
                                    'type': widget.type!,
                                    'pinned': pinPost == 1 ? '1' : '0',
                                  };
                                  await service.addChallengImage(
                                      body,
                                      widget.editedVideo!,
                                      widget.editedVideo2!);
                                } else {
                                  String filePath1 = await saveUint8ListAsFile(
                                      widget.editedImage!, 'image.jpg');
                                  String filePath2 = await saveUint8ListAsFile(
                                      widget.editedImage2!, 'image2.jpg');
                                  Map<String, String> body = {
                                    'user_id':
                                        prefs.getInt('user_id').toString(),
                                    'body': caption ?? "",
                                    'pinned': pinPost == 1 ? '1' : '0',
                                    'type': widget.type!,
                                  };
                                  await service.addChallengImage(
                                      body, filePath1, filePath2);
                                }
                                // prefs.setBool('i_just_posted', true);
                                if (bangUpdate == 1) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Nav(initialIndex: 1)));
                                }
                                else {
                                  final postsProvider = provider.Provider.of<PostsProvider>(context, listen: false);
                                  postsProvider.refreshData();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Nav(initialIndex: 0)));
                                }
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .blue, // Set the background color of the button
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Visibility(
                            visible:
                                !isLoading, // Show the CircularProgressIndicator when not loading
                            child: Text('Post'), // Display the button text
                          ),
                          Visibility(
                            visible:
                                isLoading, // Show the CircularProgressIndicator when loading
                            child: CircularProgressIndicator(), // Display the CircularProgressIndicator
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            ]))
          ],
        ));
  }

}
