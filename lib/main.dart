import 'dart:convert';
import 'package:bangapp/providers/comment_provider.dart';
import 'package:bangapp/screens/Home/home.dart';
import 'package:bangapp/screens/Posts/view_challenge_page.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/nav.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web_socket_channel/status.dart' as status;
import 'package:bangapp/screens/Authenticate/login_screen.dart';
import 'package:bangapp/screens/Chat/calls_chat.dart';
import 'package:bangapp/screens/Chat/new_message_chat.dart';
import 'package:bangapp/screens/Comments/commentspage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'models/userprovider.dart';
import 'screens/Authenticate/welcome_screen.dart';
import 'screens/Profile/edit_profile.dart';
import 'screens/Authenticate/register_screen.dart';
import 'screens/Chat/chat_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bangapp/screens/Create/final_create.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (context) => CommentProvider())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Authenticate.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        NewMessageChat.id: (context) => NewMessageChat(),
        ChatHome.id: (context) => ChatHome(),
        CallsChat.id: (context) => CallsChat(),
        Nav.id: (context) => Nav(),
        Register.id: (context) => Register(),
        Welcome.id: (context) => Welcome(),
        EditPage.id: (context) => EditPage(),
        Authenticate.id: (context) => Authenticate(),
        CommentsPage.id: (context) => CommentsPage(userId: null),
        FinalCreate.id: (context) => FinalCreate(),
      },
    );
  }
}

class Authenticate extends StatefulWidget {
  static const id = 'auth';

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late IO.Socket socket;
  @override
  void initState() {
    super.initState();
    _configureFirebaseMessaging();
    _configureLocalNotifications();
  }

  void _configureFirebaseMessaging() {
    _firebaseMessaging.getToken().then((token) {
      // Example:
      // YourAPIService.sendTokenToBackend(token);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle incoming messages when the app is in the foreground.
      String? title = message.notification?.title;
      String? body = message.notification?.body;

      if (title != null && body != null) {
        print('this is message');
        print(message.data['challenge_id']);
        _showLocalNotification(title, body);
      } else {
        print('Received message with missing title or body.');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification tap when the app is in the background or terminated.
      // Navigate the user to the relevant screen based on the notification data.
      int? challengeId = message.data['challenge_id'] != null
          ? int.tryParse(message.data['challenge_id'])
          : null;
      // Pass the challengeId to ViewChallengePage
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ViewChallengePage(challengeId: challengeId),
      ));
    });
  }

  void _configureLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String? token = snapshot.data?.getString('token');
          if (token != null) {
            return LoginScreen();
          } else {
            return LoginScreen();
          }
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
