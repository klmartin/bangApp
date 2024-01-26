
import 'package:bangapp/inspiration/inspirations.dart';
import 'package:bangapp/message/screens/chats/chats_screen.dart';
import 'package:bangapp/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final BuildContext context;

  CustomAppBar({required this.title, required this.context});

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    return AppBar(
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
          child: Stack(
            children: [
              Container(margin: EdgeInsets.only(top: 14),
                height: 30,
                width: 25,
                child: Image.asset('assets/images/chatmessage.png')),
              FutureBuilder<void>(
                future: chatProvider.getTotalUnreadMessages(),
                builder: (context, snapshot) {

                    final totalUnreadMessages = chatProvider.totalUnreadMessage;
                    return totalUnreadMessages > 0 ? Positioned(
                      top: 6,
                      child: Container(
                        height: 18,
                        width: 18,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            totalUnreadMessages.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ): Container();
                  }

              ),
            ],
          ),
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
                return BangInspiration();
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
// }

// class ChatProviderx {
//   int totalUnreadMessages = 0;

//   Future<void> getTotalUnreadMessages() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getInt('user_id');
//     final url = "http://192.168.100.118/getTotalUnreadMessages?user_id=$userId";
//     final response = await http.get(Uri.parse(url));
//     final data = jsonDecode(response.body);
//     totalUnreadMessages = data['totalUnreadMessages']; // Replace with the correct key in your JSON response.
//   }
// }
}
