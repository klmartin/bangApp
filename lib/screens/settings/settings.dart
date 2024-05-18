import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:bangapp/services/service.dart";
import 'package:bangapp/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../../services/token_storage_helper.dart';
import '../../widgets/app_bar_tittle.dart';
import 'blocked_users.dart';
import 'friends.dart';
import 'insight.dart';

class AppSettings extends StatefulWidget {
  @override
  _AppSettings createState() => _AppSettings();
}

class _AppSettings extends State<AppSettings> {
  @override
  var price;
  late bool pinPost;
  late bool subscribe;
  late UserProvider userProvider;

  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    pinPost = userProvider.userData['public'] == 1 ? true : false;
    subscribe = userProvider.userData['subscribe'] == 1 ? true : false;
    super.initState();
  }

  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppBarTitle(text: 'Settings'),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: FaIcon(FontAwesomeIcons.userPlus),
            title: Text("Invite Friends"),
            onTap: () => {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Friends()))
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.moneyBill),
            title: Text("Insights"),
            onTap: () => {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Insight())
              )
            },
          ),
          // ListTile(
          //   leading: FaIcon(FontAwesomeIcons.lock),
          //   title: Text("Notifications & Privacy"),
          // ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.person),
            title: Text("Pin Profile"),
            subtitle: subscribe
                ? TextFormField(
                    decoration: InputDecoration(
                      hintText:
                          (userProvider.userData['subscriptionPrice'] ?? 0)
                                  .toString() +
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
                      var newPrice =
                          await Service().setUserPinProfilePrice(val);
                      print(newPrice);
                      if (newPrice['message'] == 'Price set successfully') {
                        userProvider.userData['subscriptionPrice'] =
                            newPrice['subscriptionPrice'];
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
              value: subscribe,
              activeColor: Color(0xFFF40BF5), // Set the color of the thumb when the switch is active
              inactiveTrackColor: Colors.white,
              onChanged: (bool value) async {
                if(subscribe == true){
                  setState(() {
                    subscribe = !subscribe;
                  });
                  var valueRes = await Service().pinProfile();
                  userProvider.userData['subscribe'] = valueRes['value'];
                  Fluttertoast.showToast(
                    msg: valueRes['message'],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey[600],
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
                else{
                  // Show AlertDialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Your Account is going to be a business account'),
                        content: Text('33% of earnings goes to BangApp'),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF40BF5)), // Change background color
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Change text color
                            ),
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            child: Text('OK'),
                            onPressed: () async {
                              setState(() {
                                subscribe = !subscribe;
                              });
                              Navigator.of(context).pop();
                              var valueRes = await Service().pinProfile();
                              userProvider.userData['subscribe'] = valueRes['value'];
                              Fluttertoast.showToast(
                                msg: valueRes['message'],
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey[600],
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                }

              },
            ),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.message),
            title: Text("Pin Messages"),
            subtitle: pinPost
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
                      if (newPrice['message'] == 'Price set successfully') {
                        userProvider.userData['price'] = newPrice['price'];
                      }
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
              value: pinPost,
              activeColor: Color(0xFFF40BF5), // Set the color of the thumb when the switch is active
              inactiveTrackColor: Colors.white,
              onChanged: (bool value) async {
                // Show AlertDialog
                if(pinPost == true){
                  setState(() {
                    pinPost = !pinPost;
                  });
                  var valueRes = await Service().pinMessage();
                  userProvider.userData['public'] = valueRes['value'];
                  // Show toast message
                  Fluttertoast.showToast(
                    msg: valueRes['message'],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey[600],
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
                else{
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Your Account is going to be a business account'),
                        content: Text('33% of earnings goes to BangApp'),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF40BF5)), // Change background color
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Change text color
                            ),
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            child: Text('OK'),
                            onPressed: () async {
                              setState(() {
                                pinPost = !pinPost;
                              });
                              Navigator.of(context).pop();
                              var valueRes = await Service().pinMessage();
                              userProvider.userData['public'] = valueRes['value'];
                              // Show toast message
                              Fluttertoast.showToast(
                                msg: valueRes['message'],
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey[600],
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                }

              },
            ),
          ),
          // ListTile(
          //   leading: FaIcon(FontAwesomeIcons.shieldAlt),
          //   title: Text("Security"),
          // ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.shieldAlt),
            title: Text("Blocked Users"),
            onTap: () => {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => BlockedUsers())
              )
            },
          ),
          // ListTile(
          //     leading: FaIcon(FontAwesomeIcons.user), title: Text("Account")),
          // ListTile(
          //   leading: FaIcon(FontAwesomeIcons.questionCircle),
          //   title: Text("Help"),
          // ),
          // ListTile(
          //   leading: FaIcon(FontAwesomeIcons.exclamationCircle),
          //   title: Text("About"),
          // ),
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
                    content: Text("Are you sure you want to logout?"),
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
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Color(0xFFF40BF5)),
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
                          Navigator.of(context)
                              .pop(false); // Return false when canceled
                        },
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
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
