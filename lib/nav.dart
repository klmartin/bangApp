import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/custom_appbar.dart';
import 'package:bangapp/providers/chat_provider.dart';
import 'package:bangapp/screens/Explore/explore_page2.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/Activity/activity_page.dart';
import 'package:bangapp/screens/Home/Home2.dart';
import 'package:bangapp/services/service.dart';
import 'screens/Profile/profile.dart';
import 'package:bangapp/screens/Widgets/fab_container.dart';
import 'package:ionicons/ionicons.dart';
import 'package:bangapp/screens/Create/create_page.dart' as CR;


class Nav extends StatefulWidget {
  static const String id = 'nav';
  final int initialIndex;
  String? video;
  final Map<String, String>? videoBody;
  Nav({required this.initialIndex,this.video,this.videoBody});
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  bool _isAppBarEnabled = true; // Variable to track app bar state
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions ;

  @override
  void initState() {
    print("nav videooo");
    print(widget.videoBody);
    super.initState();
    _selectedIndex = widget.initialIndex;
    _widgetOptions = [
      Home2(video: widget.video,videoBody:widget.videoBody),
      BangUpdates2(),
      CR.Create(),
      Activity(),
      Profile(),
    ];
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.getTotalUnreadMessages();
  }

  @override
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
      _isAppBarEnabled = index != 2 && index != 1;
    });
  }

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
      appBar: _isAppBarEnabled ? CustomAppBar(title: 'BangApp', context: context,  ): null,
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
                future: Service().fetchNotificationCount(),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  final notificationCount = snapshot.data ?? 0;
                  bool isNotificationCountGreaterThanZero = notificationCount > 0;

                  return Visibility(
                    visible: isNotificationCountGreaterThanZero,
                    child: Positioned(
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
                            style: TextStyle(color: Colors.white, fontSize: 8),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  );
                },
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
