
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// import '../posts/create_post.dart';

//var rimage;
//var imagePicker;
enum ImageSourceType { gallery, camera }


class FabContainer extends StatefulWidget {
  final Widget? page;
  final IconData? icon;
  final bool? mini;

  FabContainer({ this.page,   this.icon, this.mini = false});

  @override
  State<FabContainer> createState() => _FabContainerState();
}

class _FabContainerState extends State<FabContainer> {

  @override
  void initState() {
    super.initState();
    //imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        return widget.page!;
      },
      closedElevation: 4.0,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(56 / 2),
        ),
      ),
      closedColor: Theme.of(context).scaffoldBackgroundColor,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            widget.icon,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            chooseUpload(context);
          },
          mini: widget.mini!,
        );
      },
    );
  }

  chooseUpload(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: .4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Center(

                 /* child: TextButton(
                    onPressed: () async {
                      XFile image = await imagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      setState(() {
                        rimage = File(image.path);
                      });
                      Navigator.pop(context,rimage);
                    },*/

                  child: Text(
                    'Choose Upload',
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
                  CupertinoIcons.camera_on_rectangle,
                  size: 25.0,
                ),
                title: Text('Choose From Gallery'),
                onTap: () {
                  // Navigator.pop(context);
                  // Navigator.of(context).push(
                  //   CupertinoPageRoute(
                  //     builder: (_) => CreatePost(),
                  //   ),
                  // );
                },
              ),
              ListTile(
                leading: Icon(
                  CupertinoIcons.camera_on_rectangle,
                  size: 25.0,
                ),
                title: Text('Upload From Camera'),
                onTap: () async {
                  // Navigator.pop(context);
                  // await viewModel.pickImage(context: context);

                },
              ),
            ],
          ),
        );
      },
    );
  }
}
