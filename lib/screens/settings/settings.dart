import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nallagram/screens/Authenticate/login_screen.dart';

class AppSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // logout functionality
              Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // logout functionality
              Navigator.pushNamed(context, LoginScreen.id);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(Icons.logout),
            ),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.userPlus),
            title: Text("Follow and Invite Friends  "),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.bell),
            title: Text("Notifications"),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.lock),
            title: Text("Privacy"),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.shieldAlt),
            title: Text("Security"),
          ),
          ListTile(
              leading: FaIcon(FontAwesomeIcons.user), title: Text("Account")),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.questionCircle),
            title: Text("Help"),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.exclamationCircle),
            title: Text("About"),
          ),
        ],
      ),
    );
  }
}
