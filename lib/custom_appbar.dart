import 'package:bangapp/inspiration/inspirations.dart' as IN;
import 'package:bangapp/message/screens/chats/chats_screen.dart';
import 'package:bangapp/providers/inprirations_Provider.dart';
import 'package:bangapp/screens/Chat/chat_home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CustomAppBar extends AppBar {
  final BuildContext context;

  CustomAppBar({required String title, required this.context})
      : super(
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'Metropolis',
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatsScreen(),
                  ),
                );
              },
              child: CachedNetworkImage(
                  height: 10,
                  width: 33,
                  imageUrl:
                      "https://img.icons8.com/fluency-systems-regular/48/chat-message.png"),
            ),
            Container(
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.only(right: 10, left: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.pink, Colors.redAccent, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: InkWell(
                child: Icon(Icons.notes_rounded),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return IN.BangInspiration();
                  }));
                },
              ),
            ),
          ],
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Colors.white,
        );
}
