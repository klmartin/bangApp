import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:video_editor/video_editor.dart';
import 'package:bangapp/screens/Create/video_editing/video_edit.dart';

class Create extends StatefulWidget {
  Create({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  AssetEntity _selectedAsset;
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  void selectAsset(AssetEntity asset) async {
    setState(() {
      _selectedAsset = asset;
      if (_selectedAsset.type == AssetType.video) {
        _initializeVideoPlayer();
      }
      else if(_selectedAsset.type == AssetType.image){
        if (_chewieController != null) {
          _chewieController.pause();
        }
      }
    });
  }

  Future<void> _initializeVideoPlayer() async {
    final file = await _selectedAsset.file;
    _videoPlayerController = VideoPlayerController.file(File(file.path));
    await _videoPlayerController.initialize();
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
      );
    });
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
        title: Text('Create Post',style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () async {
              if (_selectedAsset.type == AssetType.video) {
                var editedVideo = await _selectedAsset.file;
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoEditor(
                      video:editedVideo,
                    ),
                  ),
                );
              } else if (_selectedAsset.type == AssetType.image) {
                var editedImage = fileToUint8List(await _selectedAsset.file);
                // Redirect to image editor
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageEditor(
                      image: editedImage,
                      appBar: Colors.white,
                    ),
                  ),
                );
              }
            },
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.pink,
                    Colors.redAccent,
                    Colors.orange
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
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 2.2,
              child: Center(
                child: _selectedAsset != null
                    ? _selectedAsset.type == AssetType.video
                    ? Container(
                      height: MediaQuery.of(context).size.height / 2.2,
                      child: Chewie(
                        controller: _chewieController,
                      ),
                    )
                    : FutureBuilder<Uint8List>(
                  future: _selectedAsset.thumbnailDataWithSize(
                      ThumbnailSize(200, 200)),
                  builder:
                      (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.done) {
                      final thumbnailData = snapshot.data;
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
                )
                    : Text("Image"),
              ),
            ),
            Expanded(child: MediaGrid(selectAsset)),
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
  int lastPage;

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
            child: FutureBuilder<Uint8List>(
              future:asset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done)
                  return Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Image.memory(
                          snapshot.data,
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
                return Container();
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
        return;
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
