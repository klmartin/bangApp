import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bangapp/screens/Authenticate/login_screen.dart';
import "package:bangapp/services/service.dart";
import 'package:bangapp/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/token_storage_helper.dart';

class AppSettings extends StatefulWidget {
  @override
  _AppSettings createState() => _AppSettings();
}

class _AppSettings extends State<AppSettings> {
  @override
  var price;
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

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
            leading: FaIcon(FontAwesomeIcons.message),
            title: Text("Pin Messages"),
            subtitle: userProvider.userData['public'] == 1
                ? TextFormField(
                    decoration: InputDecoration(
                      hintText:
                          (userProvider.userData['price'] ?? 0).toString() +
                              ' Tshs',
                      focusedBorder: UnderlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number, // Allow only numbers
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Price is required';
                      }
                      // Additional validation for numbers
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Enter a valid number';
                      }
                      int price = int.parse(value);
                      if (price < 1000) {
                        return 'Price must be at least 1000';
                      }
                      return null; // Validation passed
                    },
                    onChanged: (val) async {
                      print('changed');
                      var newPrice = await Service().setUserPinPrice(val);
                      print(newPrice);
                      if (newPrice['message'] == 'Price set successfully') {
                        userProvider.userData['price'] = newPrice['price'];
                      }
                      print('this is new Price');
                      print(val);
                      Fluttertoast.showToast(
                        msg: newPrice['message'],
                        toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
                        gravity: ToastGravity.CENTER, // Toast position
                        timeInSecForIosWeb: 1, // Time duration for iOS and web
                        backgroundColor: Colors.grey[600],
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      setState(() {
                        price = val;
                      });
                    },
                  )
                : Container(),
            trailing: Switch(
              value: userProvider.userData['public'] == 1 ? true : false,
              onChanged: (value) async {
                var valueRes = await Service().pinMessage();
                userProvider.userData['public'] = valueRes['value'];
                Fluttertoast.showToast(
                  msg: valueRes['message'],
                  toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
                  gravity: ToastGravity.CENTER, // Toast position
                  timeInSecForIosWeb: 1, // Time duration for iOS and web
                  backgroundColor: Colors.grey[600],
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                // setState(() {
                //    value = ;
                // });
              },
            ),
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
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () async {

              // Show confirmation dialog
              bool confirmLogout = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Confirmation"),
                    content:
                    Text("Are you sure you want to logout?"),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context)
                              .pop(false); // Return false when canceled
                        },
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                        ),
                        child: Text("Logout"),
                        onPressed: () {
                          Navigator.of(context)
                              .pop(true); // Return true when confirmed
                        },
                      ),
                    ],
                  );
                },
              );
              // If user confirms logout
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
              // Show confirmation dialog
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
                          Navigator.of(context)
                              .pop(false); // Return false when canceled
                        },
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                        ),
                        child: Text("Delete"),
                        onPressed: () {
                          Navigator.of(context)
                              .pop(true); // Return true when confirmed
                        },
                      ),
                    ],
                  );
                },
              );
              // If user confirms deletion
              if (confirmDelete == true) {
                var delete = await Service().deleteUserAccount();

                await TokenManager.clearToken();
                await userProvider.clearUserDataFile();
                userProvider.clearUserData();

                // Navigate to login screen
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
      ),
    );
  }
}
