import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:path/path.dart' as path;
import 'package:video_player/video_player.dart';

Future<void> _getImageDimension(File file,
    { Function(Size) onResult}) async {
  var decodedImage = await decodeImageFromList(file.readAsBytesSync());
  onResult(Size(decodedImage.width.toDouble(), decodedImage.height.toDouble()));
}

String _fileMBSize(File file) =>
    ' ${(file.lengthSync() / (1024 * 1024)).toStringAsFixed(1)} MB';

class VideoResultPopup extends StatefulWidget {
  final File video;
   VideoResultPopup({@required this.video});
  @override
  State<VideoResultPopup> createState() => _VideoResultPopupState();
}

class _VideoResultPopupState extends State<VideoResultPopup> {
  VideoPlayerController _controller;
  FileImage _fileImage;
  Size _fileDimension = Size.zero;
  bool _isGif = false;
  String _fileMbSize;

  @override
  void initState() {
    super.initState();
    _isGif = path.extension(widget.video.path).toLowerCase() == ".gif";
    _fileMbSize = _fileMBSize(widget.video);
  }

  @override
  void dispose() {
    if (_isGif) {
      _fileImage?.evict();
    } else {
      _controller?.pause();
      _controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isGif) {
      _getImageDimension(
        widget.video,
        onResult: (d) => setState(() => _fileDimension = d),
      );
    } else {
      _controller ??= VideoPlayerController.file(widget.video);
      _controller.initialize().then((_) {
        _fileDimension = _controller.value.size ?? Size.zero;
        setState(() {});
        _controller?.play();
        _controller?.setLooping(true);
      });
    }

    return Padding(
      padding: const EdgeInsets.all(30),
      child: Center(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            AspectRatio(
              aspectRatio:
              _fileDimension.aspectRatio == 0 ? 1 : _fileDimension.aspectRatio,
              child: _isGif ? Image.file(widget.video) : VideoPlayer(_controller),
            ),
            Positioned(
              bottom: 0,
              child: FileDescription(
                description: {
                  'Video path': widget.video.path,
                  if (!_isGif)
                    'Video duration':
                    '${((_controller?.value.duration?.inMilliseconds ?? 0) / 1000).toStringAsFixed(2)}s',
                  'Video ratio': Fraction.fromDouble(_fileDimension.aspectRatio)
                      .reduce()
                      .toString(),
                  'Video dimension': _fileDimension.toString(),
                  'Video size': _fileMbSize,
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class CoverResultPopup extends StatefulWidget {
  const CoverResultPopup({key,  this.cover});

  final File cover;

  @override
  State<CoverResultPopup> createState() => _CoverResultPopupState();
}

class _CoverResultPopupState extends State<CoverResultPopup> {
  Uint8List _imagebytes;
  Size _fileDimension;
  String _fileMbSize;

  @override
  void initState() {
    super.initState();
    _getImageDimension(
      widget.cover,
      onResult: (d) => setState(() => _fileDimension = d),
    );
    _fileMbSize = _fileMBSize(widget.cover);
    _imagebytes = widget.cover.readAsBytesSync();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Center(
        child: Stack(
          children: [
            Image.memory(_imagebytes),
            Positioned(
              bottom: 0,
              child: FileDescription(
                description: {
                  'Cover path': widget.cover.path,
                  'Cover ratio':
                  Fraction.fromDouble(_fileDimension?.aspectRatio ?? 0)
                      .reduce()
                      .toString(),
                  'Cover dimension': _fileDimension.toString(),
                  'Cover size': _fileMbSize,
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FileDescription extends StatelessWidget {
  const FileDescription({key,  this.description});

  final Map<String, String> description;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 11),
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        padding: const EdgeInsets.all(10),
        color: Colors.black.withOpacity(0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: description.entries
              .map(
                (entry) => Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${entry.key}: ',
                    style: const TextStyle(fontSize: 11),
                  ),
                  TextSpan(
                    text: entry.value,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}