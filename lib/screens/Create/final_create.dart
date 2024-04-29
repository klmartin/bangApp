import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart' as provider;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:bangapp/services/service.dart';
import 'package:bangapp/providers/user_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../loaders/video_skeleton.dart';
import '../../nav.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import '../../providers/challenge_upload.dart';
import '../../providers/image_upload.dart';
import '../../providers/update_image_upload.dart';
import '../../providers/video_upload.dart';
import 'package:video_player/video_player.dart';
import 'package:bangapp/screens/Create/create_page.dart' as CR;

class FinalCreate extends StatefulWidget {
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

class _FinaleCreateState extends State<FinalCreate>
    with TickerProviderStateMixin {
  Service service = Service();
  late VideoPlayerController _controller;
  double? aspectRatio;
  late UserProvider userProvider;

  bool isLoading2 = false;

  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  void dispose() {
    if (_controller.value.isInitialized) {
      _controller.dispose();
    }
    captionController.dispose();
    super.dispose();
  }

  Future<double> getAspectRatioFromVideo(String videoPath) async {
    try {
      VideoPlayerController controller =
          VideoPlayerController.file(File(videoPath));
      await controller.initialize();
      double aspectRatio = controller.value.aspectRatio;
      await controller.dispose();
      return aspectRatio;
    } catch (e) {
      print('Error retrieving aspect ratio: $e');
      return 0.0; // Return a default value or handle the error as needed
    }
  }

  final captionController = TextEditingController();
  var image;
  bool light = true;
  var caption;
  var price;
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

  Future<double> getImageAspectRatio(Uint8List imageData) async {
    final image = await _loadImage(imageData);
    final aspectRatio = image.width.toDouble() / image.height.toDouble();
    return aspectRatio;
  }

  Future<ui.Image> _loadImage(Uint8List imageData) async {
    final completer = Completer<ui.Image>();
    final codec = await ui.instantiateImageCodec(imageData);
    final frame = await codec.getNextFrame();
    completer.complete(frame.image);
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    if (userProvider.userData.isEmpty) {
      userProvider.fetchUserData();
    }
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
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
          appBar: AppBar(
            titleSpacing: 8,
            title: GestureDetector(
              onTap: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CR.Create(),
                  ),
                );
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
                child: Icon(Icons.arrow_back_rounded, size: 30),
              ),
            ),
            automaticallyImplyLeading: true,
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
            children: [
              Container(
                  child: Column(children: [
                Row(
                  children: [
                    // Display the first image
                    if (widget.editedImage != null &&
                        widget.editedImage2 == null)
                      Expanded(
                        child: InkWell(
                          child: FutureBuilder<double>(
                            future: getImageAspectRatio(widget.editedImage!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // Show a loading indicator while waiting for the aspect ratio
                                return VideoSkeletonSkeleton();
                              } else if (snapshot.hasError) {
                                // Handle error
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else {
                                // Use the aspect ratio obtained from the function
                                return AspectRatio(
                                  aspectRatio: snapshot.data!,
                                  child: Container(
                                    width: 100.w,
                                    height: 50.h,
                                    child: Image.memory(
                                      widget.editedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      )
                    else if (widget.editedImage2 != null &&
                        widget.editedImage != null)
                      Expanded(
                        child: SizedBox(
                          height: 50.h,
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
                      Expanded(
                        child: FutureBuilder<double>(
                          future: getAspectRatioFromVideo(widget.editedVideo!),
                          builder: (BuildContext context,
                              AsyncSnapshot<double> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // While waiting for the aspect ratio, return a loading indicator or placeholder
                              return VideoSkeletonSkeleton();
                            } else if (snapshot.hasError) {
                              // If an error occurred while retrieving the aspect ratio, handle it accordingly
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Once the aspect ratio is retrieved, use it to build the BetterPlayer widget
                              double aspectRatio = snapshot.data ??
                                  0.5; // Use a default value if aspectRatio is null
                              return AspectRatio(
                                aspectRatio: aspectRatio,
                                child: BetterPlayer.file(
                                  widget.editedVideo!,
                                  betterPlayerConfiguration:
                                      BetterPlayerConfiguration(
                                    aspectRatio: aspectRatio,
                                    autoPlay: true,
                                    looping: true,
                                    controlsConfiguration:
                                        BetterPlayerControlsConfiguration(
                                      showControls: false,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      )
                    else if (widget.editedVideo != null &&
                        widget.editedVideo2 != null)
                      Expanded(
                        child: SizedBox(
                          height: 50.h, // Specify the desired height
                          child: PageView.builder(
                            itemCount: videos.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  width: 100.w - 4,
                                  height: 50.h,
                                  child: BetterPlayer.file(videos[index]));
                            },
                          ),
                        ),
                      )
                  ],
                ),
                SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          textCapitalization:TextCapitalization.sentences,
                          controller: captionController,
                          decoration: InputDecoration(
                            hintText: "Write a caption...",
                            border:
                                OutlineInputBorder(), // Use OutlineInputBorder for border
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Pin Post',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Switch(
                        value: pinPost == 1,
                        onChanged: (value) {
                          setState(() {
                            pinPost = value ? 1 : 0;
                          });
                        },
                        activeColor: Colors.blueGrey, // Set the color of the thumb when the switch is active
                        inactiveTrackColor: Colors.white,
                      ),
                      SizedBox(width: 20),
                      userProvider.userData['role_id'] == 1
                          ? Row(
                              children: [
                                Text(
                                  'Chemba ya Umbea',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Switch(
                                  value: bangUpdate == 1,
                                  onChanged: (value) {
                                    setState(() {
                                      bangUpdate = value ? 1 : 0;
                                    });
                                  },
                                  activeColor: Colors.blueGrey, // Set the color of the thumb when the switch is active
                                  inactiveTrackColor: Colors.white,
                                ),
                              ],
                            )
                          : Container()
                    ],
                  ),
                ),
                pinPost == 1
                    ? TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter Price!',
                          focusedBorder: UnderlineInputBorder(),
                        ),
                        keyboardType:
                            TextInputType.number, // Allow only numbers
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Price is required';
                          }
                          // Additional validation for numbers
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Enter a valid number';
                          }
                          int price = int.parse(value);
                          if (price < 1000) {
                            return 'Price must be at least 1000';
                          }
                          return null; // Validation passed
                        },
                        onChanged: (val) {
                          setState(() {
                            price = val;
                          });
                        },
                      )
                    : Container(),

                SizedBox(height: 15),
                // Initially, loading is set to false
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.0),
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
                      padding: EdgeInsets.all(2),
                      width: double.infinity,
                      child: InkWell(
                        onTap: isLoading
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
                                    double imageAspectRatio = await getImageAspectRatio(widget.editedImage!);
                                    Map<String, String> body = {
                                      'user_id':
                                          prefs.getInt('user_id').toString(),
                                      'body': captionController.text ?? " ",
                                      'pinned': pinPost == 1 ? '1' : '0',
                                      'type': widget.type!,
                                      'price': price ?? '0',
                                      'aspect_ratio': imageAspectRatio.toString()
                                    };
                                    if (bangUpdate == 1) {
                                      // await service.addBangUpdate(body, filePath);
                                      final updateImageUploadProvider =
                                          provider.Provider.of<
                                                  UpdateImageUploadProvider>(
                                              context,
                                              listen: false);
                                      updateImageUploadProvider.startUpload(
                                          body, compressedImage.path);

                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Nav(initialIndex: 1)));
                                    } else {
                                      if (pinPost == 1 && price == null) {
                                        Fluttertoast.showToast(
                                            msg: "Price is not set");
                                      } else if (pinPost == 1 &&
                                          (price.isEmpty ||
                                              int.parse(price) < 1000)) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Price is not set or less than 1000");
                                      } else {
                                        final imageUploadProvider = provider
                                                .Provider
                                            .of<ImageUploadProvider>(context,
                                                listen: false);
                                        imageUploadProvider.startUpload(
                                            body, compressedImage.path);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Nav(initialIndex: 0)),
                                        );
                                      }
                                    }
                                  } else if (widget.editedImage != null &&
                                      widget.editedImage2 == null &&
                                      widget.challengeImg == true) {
                                    String filePath = await saveUint8ListAsFile(
                                        widget.editedImage!, 'image.jpg');
                                    Map<String, String> body = {
                                      'user_id':
                                          prefs.getInt('user_id').toString(),
                                      'body': captionController.text ?? "",
                                      'post_id': widget.postId.toString(),
                                      'pinned': pinPost == 1 ? '1' : '0',
                                      'type': widget.type!,
                                      'price': price ?? '0',
                                    };
                                    await service.addChallenge(
                                        body, filePath, widget.userChallenged!);
                                  } else if (widget.editedVideo != null &&
                                      widget.editedVideo2 == null &&
                                      widget.type == 'video') {
                                    var videoAspectRatio = await getAspectRatioFromVideo( widget.editedVideo!);
                                    if (bangUpdate == 1) {
                                      print('location update');
                                      Map<String, String> body = {
                                        'user_id':
                                            prefs.getInt('user_id').toString(),
                                        'body': captionController.text ?? "",
                                        'type': widget.type!,
                                        'contentID': '20',
                                        'location': 'update',
                                        'aspect_ratio': videoAspectRatio.toString(),
                                        'pinned': pinPost == 1 ? '1' : '0',
                                        'price': price ?? '0',
                                      };
                                      final videoUploadProvider =
                                          provider.Provider.of<
                                                  VideoUploadProvider>(context,
                                              listen: false);

                                      videoUploadProvider.startUpload(
                                          body, widget.editedVideo);
                                      print(
                                          "${widget.editedVideo} this is the video");
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Nav(initialIndex: 1)));
                                    } else {
                                      if (pinPost == 1 && price == null) {
                                        Fluttertoast.showToast(
                                            msg: "Price is not set");
                                      } else if (pinPost == 1 &&
                                          (price.isEmpty ||
                                              int.parse(price) < 1000)) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Price is not set or less than 1000");
                                      } else {
                                        Map<String, String> body = {
                                          'user_id': prefs
                                              .getInt('user_id')
                                              .toString(),
                                          'body': captionController.text ?? "",
                                          'type': widget.type!,
                                          'contentID': '20',
                                          'location': 'post',
                                          'aspect_ratio':videoAspectRatio.toString(),
                                          'pinned': pinPost == 1 ? '1' : '0',
                                          'price': price ?? '0',
                                        };
                                        final videoUploadProvider = provider
                                                .Provider
                                            .of<VideoUploadProvider>(context,
                                                listen: false);

                                        videoUploadProvider.startUpload(
                                            body, widget.editedVideo);
                                        print(
                                            "${widget.editedVideo} this is the video");

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Nav(initialIndex: 0)),
                                        );
                                      }
                                    }
                                  } else if (widget.editedVideo != null &&
                                      widget.editedVideo2 != null &&
                                      widget.type == 'video') {
                                    String? filePath1 = widget.editedVideo;
                                    Map<String, String> body = {
                                      'user_id':
                                          prefs.getInt('user_id').toString(),
                                      'body': captionController.text ?? "",
                                      'contentID': '20',
                                      'aspect_ratio': aspectRatio.toString(),
                                      'type': widget.type!,
                                      'pinned': pinPost == 1 ? '1' : '0',
                                      'price': price ?? '0',
                                    };
                                    if (pinPost == 1 &&
                                        int.parse(price) < 1000) {
                                      Fluttertoast.showToast(
                                          msg: "Price is not Set");
                                    } else {
                                      final challengeUploadProvider = provider
                                              .Provider
                                          .of<ChallengeUploadProvider>(context,
                                              listen: false);

                                      challengeUploadProvider.startUpload(
                                          body,
                                          widget.editedVideo!,
                                          widget.editedVideo2!);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Nav(initialIndex: 0)),
                                      );
                                    }
                                  } else {
                                    String filePath1 =
                                        await saveUint8ListAsFile(
                                            widget.editedImage!, 'image.jpg');
                                    String filePath2 =
                                        await saveUint8ListAsFile(
                                            widget.editedImage2!, 'image2.jpg');
                                    Map<String, String> body = {
                                      'user_id':
                                          prefs.getInt('user_id').toString(),
                                      'body': captionController.text ?? "",
                                      'pinned': pinPost == 1 ? '1' : '0',
                                      'price': price ?? '0',
                                      'type': widget.type!,
                                    };
                                    if (pinPost == 1 && price == null) {
                                      Fluttertoast.showToast(
                                          msg: "Price is not set");
                                    } else if (pinPost == 1 &&
                                        (price.isEmpty ||
                                            int.parse(price) < 1000)) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Price is not set or less than 1000");
                                    } else {
                                      final challengeUploadProvider = provider
                                              .Provider
                                          .of<ChallengeUploadProvider>(context,
                                              listen: false);

                                      challengeUploadProvider.startUpload(
                                          body, filePath1, filePath2);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Nav(initialIndex: 0)),
                                      );
                                    }
                                  }
                                } finally {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                        child: Center(
                          child: Text(
                            'Post',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]))
            ],
          ));
    });
  }
}
