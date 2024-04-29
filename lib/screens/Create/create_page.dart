import 'dart:io';
import 'dart:typed_data';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:bangapp/screens/Create/video_editing/video_edit.dart';

class Create extends StatefulWidget {
  Create({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  List<AssetEntity> _selectedAssets = [];

  int _activePage = 0;
  final PageController _pageViewController =
      PageController(initialPage: 0); // set the initial page you want to show

  void selectAsset(AssetEntity asset) async {
    setState(() {
      if (_selectedAssets.contains(asset)) {
        _selectedAssets.remove(asset);
      } else {
        if (_selectedAssets.length < 2) {
          _selectedAssets.add(asset);
        } else {
          // Show a message or alert that only two images can be selected
        }
      }
      if (_selectedAssets.isNotEmpty) {
        if (_selectedAssets[0].type == AssetType.video) {
          _initializeVideoPlayer();
        } else if (_selectedAssets[0].type == AssetType.image) {

        }
      } else {

      }
    });
  }

  Future<void> _initializeVideoPlayer() async {
    if (_selectedAssets.isNotEmpty) {
      var videoControllers = <VideoPlayerController>[];
      for (var asset in _selectedAssets) {
        var file = await asset.file;
        var controller = VideoPlayerController.file(File(file!.path));
        await controller.initialize();
        videoControllers.add(controller);
      }
      setState(() {

      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _pageViewController.dispose();
  }

  Uint8List fileToUint8List(File file) {
    final bytes = file.readAsBytesSync();
    return Uint8List.fromList(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Post',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () async {
              if (_selectedAssets.isNotEmpty) {
                if (_selectedAssets[0].type == AssetType.video) {
                  var editedVideo = await _selectedAssets[0].file;
                  if (_selectedAssets.length == 2) {
                    var editedVideo2 = await _selectedAssets[1].file;
                    print([editedVideo,editedVideo2]);
                    print('these are the selected items');
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoEditor(
                          video: editedVideo!,
                          video2: editedVideo2!,
                        ),
                      ),
                    );
                  }
                  else{

                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoEditor(
                          video: editedVideo!,
                        ),
                      ),
                    );
                  }

                } else if (_selectedAssets[0].type == AssetType.image) {
                  Uint8List? editedImage;
                  Uint8List? editedImage2;
                  var filee = await _selectedAssets[0].file;
                  editedImage = fileToUint8List(filee!);
                  if (_selectedAssets.length == 2) {
                    var filee2 = await _selectedAssets[1].file;
                    editedImage2 = fileToUint8List(filee2!);
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageEditor(
                            image: editedImage,
                            image2: editedImage2,
                            allowMultiple: true),
                      ),
                    );
                  } else {
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageEditor(
                          image: editedImage,
                        ),
                      ),
                    );
                  }
                }
              }
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
              child: Icon(Icons.navigate_next, size: 30),
            ),
          ),
          SizedBox(width: 10)
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 2.2,
                  child: PageView.builder(
                    controller: _pageViewController,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (int index) {
                      setState(() {
                        _activePage = index;
                      });
                    },
                    itemCount: _selectedAssets.length,
                    itemBuilder: (context, index) {
                      final asset = _selectedAssets[index];
                      if (asset.type == AssetType.video) {
                        return FutureBuilder<File?>(
                          future: asset.file,
                          builder: (BuildContext context, AsyncSnapshot<File?> fileSnapshot) {
                            if (fileSnapshot.connectionState == ConnectionState.done && fileSnapshot.hasData) {
                              final videoController = VideoPlayerController.file(fileSnapshot.data!);
                              return Container(
                                height: MediaQuery.of(context).size.height / 2.2,
                                width: MediaQuery.of(context).size.width,
                                child: BetterPlayer.file(
                                    fileSnapshot.data!.path,
                                  betterPlayerConfiguration:
                                  BetterPlayerConfiguration(
                                    fit: BoxFit.fitHeight,
                                    aspectRatio: (MediaQuery.of(context).size.height / 2.2) / (MediaQuery.of(context).size.width),
                                    autoPlay: true,
                                    looping: true,
                                    controlsConfiguration:
                                    BetterPlayerControlsConfiguration(
                                      showControls: false,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Color(0xFFF40BF5), size: 30));
                            }
                          },
                        );
                      } else {
                        return FutureBuilder<Uint8List?>(
                          future: asset.thumbnailDataWithSize(ThumbnailSize(_selectedAssets[index].height.toInt(),  _selectedAssets[index].width.toInt())),
                          builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              final thumbnailData = snapshot.data!;
                              return Image.memory(
                                thumbnailData,
                                // Consider using BoxFit.cover or BoxFit.fill based on your layout
                                fit: BoxFit.contain,
                                height: _selectedAssets[index].height.toDouble(),
                                width: _selectedAssets[index].width.toDouble(),
                              );
                              // Handle errors if any
                            } else {
                              // Loading indicator while waiting for the thumbnail
                              return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Color(0xFFF40BF5), size: 30));
                            }
                          },
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  child: MediaGrid(selectAsset),
                ),
              ],
            ),
            if( _selectedAssets.length > 1)
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 75,
              left: 0,
              right: 0,
              height: 40,
              child:Container(
                width: 50,
                height: 34,
                decoration: ShapeDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    _pageViewController.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Center the text and icon horizontally
                    children: [
                      Text(
                        "Swipe to View B",
                        style: TextStyle(
                          color: Colors.black, // Change text color if needed
                          fontWeight: FontWeight.bold, // Add any desired text styles
                        ),
                      ),
                      Icon(
                        Icons.navigate_next_outlined, // Replace with the desired icon
                        color: Colors.redAccent, // Set the icon color
                        size: 24, // Set the icon size
                      ),
                      SizedBox(width: 8),// Add some spacing between the icon and text
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MediaGrid extends StatefulWidget {
  final Function(AssetEntity) onSelectAsset;
  MediaGrid(this.onSelectAsset);
  @override
  _MediaGridState createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid> {
  List<Widget> _mediaList = [];
  int currentPage = 0;
  late int lastPage;

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    lastPage = currentPage;
    var result = await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(onlyAll: true);
    List<AssetEntity> media =
        await albums[0].getAssetListPaged(page: currentPage, size: 80);
    List<Widget> temp = [];
    for (var asset in media) {
      temp.add(
        GestureDetector(
          onTap: () {
            widget.onSelectAsset(asset);
          },
          child: FutureBuilder<Uint8List?>(
            future: asset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
            builder:
                (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (asset.type == AssetType.video)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 5, bottom: 5),
                            child: Icon(
                              Icons.videocam,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  );
                } else {
                  return Container();
                }
              } else {
                return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Color(0xFFF40BF5), size: 30));
              }
            },
          ),
        ),
      );
    }
    setState(() {
      _mediaList.addAll(temp);
      currentPage++;
    });
    }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        _handleScrollEvent(scroll);
        return true;
      },
      child: GridView.builder(
        itemCount: _mediaList.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          return _mediaList[index];
        },
      ),
    );
  }
}
