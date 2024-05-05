import 'package:bangapp/custom_appbar.dart';
import 'package:bangapp/message/constants.dart';
import 'package:bangapp/providers/chat_provider.dart';
import 'package:bangapp/screens/Activity/activity_page.dart';
import 'package:bangapp/screens/Create/create_page.dart' as CR;
import 'package:bangapp/screens/Home/Home2.dart';
import 'package:bangapp/screens/Profile/profile.dart';
import 'package:bangapp/widgets/app_bar_tittle.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/body.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late final IO.Socket socket;

  @override
  void initState() {
    super.initState();
    connect();
    getUserConversations();
  }

  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    return userId ?? 0; // Handle null or non-integer values
  }

  void getUserConversations() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.getAllConversations(context, await getUserId());
  }

  void connect() {
    socket = IO.io('wss://bangapp.pro:3000/', <String, dynamic>{
      "transports": ['websocket'],
      "autoconect": false,
    });
    socket.connect();
    socket.onConnect((_) {
      print("Connected to frontend");
    });

    socket.on('updateLastMessageInConversation', (lastMessage){
        print("updateLastMessageInConverstion");
        print(lastMessage);
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        chatProvider.updateLastMessageInConverstion(lastMessage);
        });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(text: ""),
        automaticallyImplyLeading: false,
      ),
      body: const Body(),
    );
  }

  int _selectedIndex = 0;
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.messenger), label: "Chats"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "People"),
        BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 14,
            backgroundImage: AssetImage("assets/images/user_2.png"),
          ),
          label: "Profile",
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      automaticallyImplyLeading: false,
      title: const Text("Chats"),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }
}
