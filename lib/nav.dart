import 'package:bangapp/inspiration/inspirations.dart';
import 'package:bangapp/screens/Explore/explore_page2.dart';
import 'package:bangapp/screens/Home/home3.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:bangapp/screens/blog/blog_home.dart';
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
    Activity(),
    // BangInspiration(),
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
      appBar: _isAppBarEnabled // Conditionally show/hide app bar
          ? AppBar(
              automaticallyImplyLeading: false,
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: Text(
                'BangApp',
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
              actions: [
                //   IconButton(
                //     icon: Icon(
                //       Ionicons.chatbubble_outline,
                //       color: Colors.red,
                //     ),
                //     onPressed: () {
                //       Navigator.pushNamed(context, ChatHome.id);
                //     },
                //   ),

                CachedNetworkImage(
                    height: 10,
                    width: 33,
                    imageUrl:
                        "https://img.icons8.com/fluency-systems-regular/48/chat-message.png"),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BlogHome()),
                    );
                  },
                  child: Container(
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
                    child: Icon(Icons.notes_rounded),
                  ),
                ),
              ],
            )
          : null, // Hide app bar when _isAppBar    Enabled is false

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
          FaIcon(
            FontAwesomeIcons.heart,
            size: 25.0,
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
