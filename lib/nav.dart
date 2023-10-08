
import 'package:bangapp/custom_appbar.dart';
import 'package:bangapp/services/service.dart';
import 'package:bangapp/screens/Explore/explore_page2.dart';
import 'package:bangapp/screens/Home/home3.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'screens/Activity/activity_page.dart';
import 'package:bangapp/screens/Home/Home2.dart';
import 'screens/Create/create_page.dart';
import 'screens/Chat/chat_home.dart';
import 'screens/Profile/profile.dart';
import 'package:bangapp/screens/Widgets/fab_container.dart';
import 'package:ionicons/ionicons.dart';

class Nav extends StatefulWidget {
  static const String id = 'nav';
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  bool _isAppBarEnabled = true; // Variable to track app bar state
  @override
  void initState() {
    super.initState();
  }

  @override
  int _selectedIndex = 0;
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
      _isAppBarEnabled = index != 2 && index != 1;
    });
  }

  List<Widget> _widgetOptions = [
    Home2(),
    BangUpdates2(),
    Create(),
    Activity(),
    Profile(),
  ];

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      appBar: CustomAppBar(title: 'BangApp', context: context),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey.shade200,
        buttonBackgroundColor: Colors.redAccent.shade100,
        height: 50.0,
        color: Colors.white,
        items: <Widget>[
          Icon(
            Icons.home,
            color: Colors.black,
            size: 25,
          ),
          Icon(
            Icons.search,
            color: Colors.black,
            size: 25.0,
          ),
          Icon(
            Icons.create_outlined,
            color: Colors.black,
            size: 25.0,
          ),
          Stack(
            children:[
              FaIcon(
              FontAwesomeIcons.heart,
              size: 25.0),
              FutureBuilder<int>(
                future: Service().fetchNotificationCount(), // Pass the user ID as an argument
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    // Use the notification count obtained from the API in the child widget.
                    final notificationCount = snapshot.data ?? 0;
                    return Positioned(
                      left: 5,
                      top: 10,
                      child: Container(
                        height: 15,
                        width: 15,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            notificationCount.toString(),
                            textAlign: TextAlign.center,

                            style: TextStyle(color: Colors.white,fontSize: 8),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }
              )

            ],
          ),
          Icon(
            Icons.person_outline,
            color: Colors.black,
            size: 25.0,
          ),
        ],
        index: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }

  buildFab() {
    return Container(
      height: 45.0,
      width: 45.0,
      // ignore: missing_required_param
      child: FabContainer(
        icon: Ionicons.add_outline,
        mini: true,
      ),
    );
  }
}
