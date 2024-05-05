import 'package:flutter/material.dart';

import 'back_button.dart';

class AppBarTitle extends StatelessWidget {
  final String text;

  const AppBarTitle({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);
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

