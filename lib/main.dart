import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/message/screens/messages/message_screen.dart';
import 'package:bangapp/providers/BoxDataProvider.dart';
import 'package:bangapp/providers/Profile_Provider.dart';
import 'package:bangapp/providers/bang_update_provider.dart';
import 'package:bangapp/providers/chat_provider.dart';
import 'package:bangapp/providers/comment_provider.dart';
import 'package:bangapp/providers/inprirations_Provider.dart';
import 'package:bangapp/providers/post_likes.dart';
import 'package:bangapp/providers/posts_provider.dart';
import 'package:bangapp/screens/Posts/postView_model.dart';
import 'package:bangapp/screens/Posts/view_challenge_page.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/nav.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:bangapp/screens/Authenticate/login_screen.dart';
import 'package:bangapp/screens/Chat/calls_chat.dart';
import 'package:bangapp/screens/Chat/new_message_chat.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:bangapp/screens/Create/video_editing/video_edit.dart';
import 'firebase_options.dart';
import 'models/userprovider.dart';
import 'screens/Authenticate/welcome_screen.dart';
import 'screens/Profile/edit_profile.dart';
import 'screens/Authenticate/register_screen.dart';
import 'screens/Chat/chat_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bangapp/screens/Create/final_create.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bangapp/services/service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  // Listen for shared data when the app starts
  if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (context) => CommentProvider()),
    ChangeNotifierProvider(create: (context) => PostsProvider()),
    ChangeNotifierProvider(create: (context) => BangInspirationsProvider()),
    ChangeNotifierProvider(create: (context) => BangUpdateProvider()),
    ChangeNotifierProvider(create: (context) => ChatProvider()),
    ChangeNotifierProvider(create: (context) => BoxDataProvider()),
    ChangeNotifierProvider(create: (context) => ProfileProvider()),
    ChangeNotifierProvider(create: (context) => UserLikesProvider()),
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
        Nav.id: (context) => Nav(initialIndex: 0),
        Register.id: (context) => Register(),
        Welcome.id: (context) => Welcome(),
        EditPage.id: (context) => EditPage(),
        Authenticate.id: (context) => Authenticate(),
        // CommentsPage.id: (context) => CommentsPage(userId: null),
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
  late StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile>? _sharedFiles;
  String? _sharedText;
  Uint8List fileToUint8List(File file) {
    final bytes = file.readAsBytesSync();
    return Uint8List.fromList(bytes);
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late IO.Socket socket;
  @override
  void initState() {
    super.initState();
    _configureFirebaseMessaging();
    _configureLocalNotifications();
    // For sharing images coming from outside the app while the app is in memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getMediaStream().listen(
      (List<SharedMediaFile> value) {
        // Check the first shared file's extension
        final firstSharedFile = value.isNotEmpty ? value[0] : null;
        if (firstSharedFile != null) {
          final filePath = firstSharedFile.path;
          if (filePath.toLowerCase().endsWith('.jpg') ||
              filePath.toLowerCase().endsWith('.png') ||
              filePath.toLowerCase().endsWith('.jpeg')) {
            // It's an image
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ImageEditor(
                  image: fileToUint8List(File(filePath)),
                  allowMultiple: true,
                ),
              ),
            );
          } else if (filePath.toLowerCase().endsWith('.mp4') ||
              filePath.toLowerCase().endsWith('.avi')) {
            // It's a video
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VideoEditor(
                  video: File(filePath),
                ),
              ),
            );
          } else {
            // Handle other file types or show an error message
            print('Unsupported file type: $filePath');
          }
        }
        setState(() {
          _sharedFiles = value;
          print("Shared:" + (_sharedFiles?.map((f) => f.path).join(",") ?? ""));
        });
      },
      onError: (err) {
        print("getIntentDataStream error: $err");
      },
    );

// For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      // Check the first shared file's extension
      final firstSharedFile = value.isNotEmpty ? value[0] : null;
      if (firstSharedFile != null) {
        final filePath = firstSharedFile.path;
        if (filePath.toLowerCase().endsWith('.jpg') ||
            filePath.toLowerCase().endsWith('.png')) {
          // It's an image
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ImageEditor(
                image: fileToUint8List(File(filePath)),
                allowMultiple: true,
              ),
            ),
          );
        } else if (filePath.toLowerCase().endsWith('.mp4') ||
            filePath.toLowerCase().endsWith('.avi')) {
          // It's a video
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VideoEditor(
                video: File(filePath),
              ),
            ),
          );
        } else {
          // Handle other file types or show an error message
          print('Unsupported file type: $filePath');
        }
      }
      setState(() {
        _sharedFiles = value;
        print("Shared:" + (_sharedFiles?.map((f) => f.path).join(",") ?? ""));
      });
    });
  }

  void _configureFirebaseMessaging() {
    _firebaseMessaging.getToken().then((token) {
      // Example:
      // YourAPIService.sendTokenToBackend(token);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.data["type"]);
      // Handle incoming messages when the app is in the foreground.
      String? title = message.notification?.title;
      String? body = message.notification?.body;

      if (message.data["type"] == "message") {
        int notificationId = int.parse(message.data['notification_id']);
        String? userName = message.data['user_name'];
      print("THis is of object type ${notificationId.runtimeType} and is $notificationId user is $userName");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagesScreen(
                notificationId,
                message.data['user_name'] ?? "Username",
                logoUrl
            ),
          ),
        );
      }

      if (title != null && body != null) {
        _showLocalNotification(title, body);
      } else {
        print('Received message with missing title or body.');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // Handle notification tap when the app is in the background or terminated.
      // Navigate the user to the relevant screen based on the notification data.
      if (message.data["type"] == "message") {
        int notificationId = int.parse(message.data['notification_id']);
        String? userName = message.data['user_name'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagesScreen(
                notificationId,
                userName ?? "Username",
                logoUrl
            ),
          ),
        );
      }

      if (message.data["type"] == "like" || message.data["type"] == "comment") {
        int notificationId = int.parse(message.data['notification_id']);
        String? userName = message.data['user_name'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userId = prefs.getInt('user_id');
        var postData = await Service().getPostInfo(message.data['notification_id'],userId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => POstView(
                postData[0]['user']['name'],
                postData[0]['body'] ?? "",
                postData[0]['image'],
                postData[0]['challenge_img'] ?? '',
                postData[0]['width'],
                postData[0]['height'],
                postData[0]['id'],
                postData[0]['commentCount'],
                postData[0]['user']['id'],
                postData[0]['isLiked'],
                postData[0]['like_count_A'] ?? 0,
                postData[0]['type'],
                postData[0]['user']['followerCount'],
                postData[0]['created_at']  ?? '',
                postData[0]['user_image_url'],
                postData[0]['pinned'],
                Provider.of<ProfileProvider>(context, listen: false)
            ),
          ),
        );
      }
      if (message.data["type"] == "challenge") {

        print('this is the challenge data');
        print(message.data["notification_id"]);
        int? challengeId = message.data['notification_id'] != null
            ? int.tryParse(message.data['notification_id'])
            : null;
        // Pass the challengeId to ViewChallengePage
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ViewChallengePage(challengeId: challengeId),
        ));
      }
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
            return Nav(initialIndex: 0);
          } else {
            return Welcome();
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
