import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
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
  List<ChewieController?> chewieControllerList = [];
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
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
          if (_chewieController != null) {
            _chewieController!.pause();
          }
        }
      } else {
        _videoPlayerController?.dispose();
        _chewieController?.dispose();
        _videoPlayerController = null;
        _chewieController = null;
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
        _chewieController = ChewieController(
          videoPlayerController: videoControllers[0], // Display the first video
          autoPlay: true,
          looping: true,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _videoPlayerController = null;
    _chewieController = null;
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
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
                  colors: [Colors.pink, Colors.redAccent, Colors.orange],
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
                              final chewieController = ChewieController(
                                videoPlayerController: videoController,
                                autoPlay: true,
                                looping: true,
                                aspectRatio:_chewieController?.aspectRatio
                              );
                              videoController.initialize().then((_) {
                                setState(() {
                                  // Update the Chewie controller once the video is initialized
                                  chewieControllerList[index] = chewieController;
                                });
                              });
                              return Container(
                                height: MediaQuery.of(context).size.height / 2.2,
                                width: MediaQuery.of(context).size.width,
                                child: Chewie(controller: chewieController),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        );
                      } else {
                        return FutureBuilder<Uint8List?>(
                          future: asset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
                          builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              final thumbnailData = snapshot.data!;
                              return Image.memory(
                                thumbnailData,
                                height: _selectedAssets[index].height.toDouble(),
                                width:  _selectedAssets[index].width.toDouble(),
                                fit: BoxFit.contain,
                              );
                            } else {
                              return CircularProgressIndicator();
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
    if (result != null) {
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
                  return CircularProgressIndicator();
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
    } else {
      // Handle permission denied
    }
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
