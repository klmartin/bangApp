import 'package:flutter/material.dart';

import '../nav.dart';
import 'back_button.dart';

class AppBarTitle extends StatelessWidget {
  final String text;
  final bool? isFromNav;
  final int? navIndex;
  const AppBarTitle({Key? key, required this.text, this.isFromNav, this.navIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isFromNav ?? false) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Nav(initialIndex: navIndex ?? 0,)),
          );
        } else {
          Navigator.pop(context);
        }
      },
      child: Row(
        children: [
          CustomBackButton(),
          SizedBox(width: 8), // Add some space between the icon and the text
          Text(text),
        ],
      ),
    );
  }
}

