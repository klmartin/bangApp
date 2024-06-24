import 'package:bangapp/providers/user_provider.dart';
import 'package:bangapp/screens/settings/friends.dart';
import 'package:bangapp/services/service.dart';
import 'package:bangapp/services/token_storage_helper.dart';
import 'package:bangapp/widgets/app_bar_tittle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'blocked_users.dart';

class AppleSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppBarTitle(
            text: 'Settings'), // Assuming AppBarTitle is a custom widget
        backgroundColor: Colors.white,
      ),
      body: SettingsList(), // Custom widget that contains your settings list
    );
  }
}

class SettingsList extends StatefulWidget {
  @override
  _SettingsListState createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  bool subscribe = false;
  bool pinPost = false;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    return ListView(
      children: <Widget>[
        ListTile(
          leading: FaIcon(FontAwesomeIcons.userPlus),
          title: Text("Invite Friends"),
          onTap: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Friends())),
        ),
         ListTile(
            leading: FaIcon(FontAwesomeIcons.shieldAlt),
            title: Text("Blocked Users"),
            onTap: () => {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => BlockedUsers())
              )
            },
          ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text("Logout"),
          onTap: () async {
            bool confirmLogout = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirmation"),
                  content: Text("Are you sure you want to logout?"),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFFF40BF5)),
                      ),
                      child: Text("Logout"),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              },
            );
            if (confirmLogout == true) {
              await TokenManager.clearToken();
              await userProvider.clearUserDataFile();
              userProvider.clearUserData();
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
        ),
        ListTile(
          leading: Icon(Icons.delete_forever),
          title: Text("Delete Account"),
          onTap: () async {
            bool confirmDelete = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirmation"),
                  content:
                      Text("Are you sure you want to delete your account?"),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      child: Text("Delete"),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              },
            );
            if (confirmDelete == true) {
              var delete = await Service().deleteUserAccount();
              await TokenManager.clearToken();
              await userProvider.clearUserDataFile();
              userProvider.clearUserData();
              Fluttertoast.showToast(
                msg: delete['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey[600],
                textColor: Colors.white,
                fontSize: 16.0,
              );
              if (delete['message'] == "User account deleted successfully") {
                Navigator.pushReplacementNamed(context, '/login');
              }
            }
          },
        ),
      ],
    );
  }
}
