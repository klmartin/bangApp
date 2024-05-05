
import 'package:bangapp/loaders/notification_skeleton.dart';
import 'package:bangapp/services/service.dart';
import 'package:bangapp/widgets/app_bar_tittle.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import '../../loaders/insight_skeleton.dart';
import '../../providers/blocked_users_provider.dart';
import '../../providers/insights_provider.dart';
import 'package:bangapp/screens/Profile/user_profile.dart';

class BlockedUsers extends StatefulWidget {
  @override
  _BlockedUsersState createState() => _BlockedUsersState();
}

class _BlockedUsersState extends State<BlockedUsers> {
  @override
  void initState() {
    super.initState();
    Provider.of<BlockedUsersProvider>(context, listen: false).fetchBlockedUsers();
  }

  ListTile BlockedUsersList(blockedUsers) {
    final blockedUsersProvider =
    Provider.of<BlockedUsersProvider>(context, listen: true);
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfile(userid: blockedUsers['user_blocked_id']),
            ),
          );
        },
        child: CircleAvatar(
          backgroundImage: NetworkImage(blockedUsers['user_image_url']),
          radius: 28.0,
        ),
      ),
      title: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfile(userid: blockedUsers['user_blocked_id']),
            ),
          );
        },
        child: Text(
          blockedUsers['user']['name'],
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
      ),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () async {
              var message = await blockedUsersProvider.unblockUserByID(blockedUsers['user_blocked_id']);
                Fluttertoast.showToast(msg: message);
            },
            child:blockedUsersProvider.unblocking ?  LoadingAnimationWidget.staggeredDotsWave(
                color: Color(0xFFF40BF5), size: 30) : Text('Unblock'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final blockedUsersProvider =
        Provider.of<BlockedUsersProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title:AppBarTitle(text: "Blocked Users")
      ),
      body: blockedUsersProvider.loading ? NotificationSkeleton() :  ListView.builder(
        itemCount: blockedUsersProvider.blockedUsers.length,
        itemBuilder: (BuildContext context, int index) {
          var blockedUser = blockedUsersProvider.blockedUsers[index];
          return BlockedUsersList(blockedUser);
        },
      ),
    );
  }
}

