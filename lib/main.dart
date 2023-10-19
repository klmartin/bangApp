import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bangapp/providers/BoxDataProvider.dart';
import 'package:bangapp/providers/chat_provider.dart';
import 'package:bangapp/providers/comment_provider.dart';
import 'package:bangapp/providers/home_provider.dart';
import 'package:bangapp/providers/inprirations_Provider.dart';
import 'package:bangapp/providers/posts_provider.dart';
import 'package:bangapp/screens/Explore/explore_page2.dart';
import 'package:bangapp/screens/Posts/view_challenge_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/nav.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:bangapp/screens/Authenticate/login_screen.dart';
import 'package:bangapp/screens/Chat/calls_chat.dart';
import 'package:bangapp/screens/Chat/new_message_chat.dart';
import 'package:bangapp/screens/Comments/commentspage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:bangapp/screens/Create/video_editing/video_edit.dart';
import 'models/userprovider.dart';
import 'screens/Authenticate/welcome_screen.dart';
import 'screens/Profile/edit_profile.dart';
import 'screens/Authenticate/register_screen.dart';
import 'screens/Chat/chat_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bangapp/screens/Create/final_create.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Listen for shared data when the app starts
  await Firebase.initializeApp();


OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
OneSignal.initialize("20d92df9-89dd-49a4-841c-4407d017edb6");
// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
OneSignal.Notifications.requestPermission(true);
      print(OneSignal.User.pushSubscription.token);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (context) => CommentProvider()),
    ChangeNotifierProvider(create: (context) => PostsProvider()),
    ChangeNotifierProvider(create: (context) => BangInspirationsProvider()),
    // ChangeNotifierProvider(create: (context) => HomeProvider()),
    ChangeNotifierProvider(create: (context) => BangUpdateProvider()),
    ChangeNotifierProvider(create: (context) => ChatProvider()),
    ChangeNotifierProvider(create: (context) => BoxDataProvider()),
  ], child: MyApp()));
}

Future accosiateUseWithOneSignal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
     OneSignal.login(userId.toString());
  }



class MyApp extends StatelessWidget {

  late final GoogleSignInAccount user;
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
        EditPage.id: (context) => EditPage(user: user),
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
    accosiateUseWithOneSignal();
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
                  video: File(filePath)!,
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
                video: File(filePath)!,
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
            return Nav();
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
