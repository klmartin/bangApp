import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bangapp/screens/Authenticate/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
      ),
      body: ListView(
        children: <Widget>[

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
          ListTile(
            leading: Icon(
                Icons.logout
            ),
            title: Text("Logout"),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('token');
              Navigator.pushNamed(context, LoginScreen.id);
            },
          ),
        ],
      ),
    );
  }
}
