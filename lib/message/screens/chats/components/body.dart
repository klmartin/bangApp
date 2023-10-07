import 'package:bangapp/message/components/filled_outline_button.dart';
import 'package:bangapp/message/constants.dart';
import 'package:bangapp/message/models/Chat.dart' as Chat;
import 'package:bangapp/message/screens/messages/message_screen.dart';
import 'package:bangapp/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_card.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  Future<int?> getUserIdFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id'); // Use 12 as the default value
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
          color:  kPrimaryColor,
          //   padding: const EdgeInsets.fromLTRB(
          //       kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
          //   color: kPrimaryColor,
          //   child: Row(
          //     children: [
          //       FillOutlineButton(press: () {}, text: "Recent Message"),
          //       const SizedBox(width: kDefaultPadding),
          //       FillOutlineButton(
          //         press: () {},
          //         text: "Active",
          //         isFilled: false,
          //       ),
          //     ],
          //   ),
        ),
     Expanded(
          child: Consumer<ChatProvider>(
              builder: (BuildContext context, value, Widget? child) {
            return FutureBuilder<void>(
              future: () async {
                final chatProvider = Provider.of<ChatProvider>(context);
                final userId = await getUserIdFromSharedPreferences();
                if (chatProvider.shouldRefresh) {
                  await chatProvider.getAllConversations(context, userId!);
                  chatProvider.setShouldRefresh(false);
                }
              }(),
              builder: (context, snapshot) {
               if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final chatProvider = Provider.of<ChatProvider>(context);

                  final conversations =
                      chatProvider.conversations;

                  return ListView.builder(
                      itemCount: conversations.length,
                      itemBuilder: (context, index) {
                        final conv = conversations[index];
                        return  ChatCard(
                            key: Key(conv.id.toString()),
                          chat: Chat.Chat(
                            name: conv.receiverName ?? "",
                            lastMessage:
                                conv.lastMessage ?? "Last Message Here",
                            image: "assets/images/app_iconw.jpg",
                            time: conv.time ?? "3 minutes Ago",
                            isActive: true,
                            unreadCount: conv.unreadCount,
                          ),
                          press: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MessagesScreen(
                                  conv.receiverId ?? 0,
                                  conv.receiverName ?? "Username"),
                            ),
                          ),
                        );
                      });
                }
              },
            );
          }),
        ),
      ],
    );
  }
}