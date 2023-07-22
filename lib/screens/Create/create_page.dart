import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:bangapp/screens/Create/video_editing/video_edit.dart';
import '../../services/animation.dart';

class Create extends StatefulWidget {
  Create({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  List<AssetEntity> _selectedAssets = [];
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

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
    var file = await _selectedAssets[0].file;
    _videoPlayerController = VideoPlayerController.file(File(file!.path));
    await _videoPlayerController!.initialize();
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: true,
      );
    });
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
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoEditor(
                        video: editedVideo!,
                      ),
                    ),
                  );
                }
                else if (_selectedAssets[0].type == AssetType.image) {
                  Uint8List? editedImage;
                  Uint8List ? editedImage2;
                  var filee = await _selectedAssets[0].file;
                  editedImage = fileToUint8List(filee!);
                  if (_selectedAssets.length == 2) {
                    var filee2 = await _selectedAssets[1].file;
                    editedImage2 = fileToUint8List(filee2!);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageEditor(
                            image: editedImage,
                            image2: editedImage2,
                            allowMultiple: true
                        ),
                      ),
                    );
                  }
                  else{
                    await Navigator.push(
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                      height: MediaQuery.of(context).size.height / 2.2,
                      child: PageView(
                        scrollDirection: Axis.horizontal, // Set the scroll direction to horizontal
                        children: _selectedAssets.map((asset) {
                          if (asset.type == AssetType.video) {
                            return Container(
                              height: MediaQuery.of(context).size.height / 2.2,
                              child: Chewie(
                                controller: _chewieController!,
                              ),
                            );
                          } else {
                            return FutureBuilder<Uint8List?>(
                              future: asset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
                              builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  final thumbnailData = snapshot.data!;
                                  return Image.memory(
                                    thumbnailData,
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                            );
                          }
                        }).toList(),
                      )
                  ),
                  Expanded(child: MediaGrid(selectAsset)),
                ],
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
              builder: (BuildContext context,
                  AsyncSnapshot<Uint8List?> snapshot) {
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
                              padding:
                              EdgeInsets.only(right: 5, bottom: 5),
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

