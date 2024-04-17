import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bangapp/providers/create_post_provider.dart';
import 'package:bangapp/providers/update_image_upload.dart';
import 'package:bangapp/screens/Comments/notification_comment.dart';
import 'package:bangapp/widgets/splash_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:bangapp/constants/urls.dart';
import 'package:bangapp/message/screens/messages/message_screen.dart';
import 'package:bangapp/providers/BoxDataProvider.dart';
import 'package:bangapp/providers/Profile_Provider.dart';
import 'package:bangapp/providers/bang_update_provider.dart';
import 'package:bangapp/providers/battle_comment_provider.dart';
import 'package:bangapp/providers/challenge_upload.dart';
import 'package:bangapp/providers/chat_provider.dart';
import 'package:bangapp/providers/comment_provider.dart';
import 'package:bangapp/providers/follower_provider.dart';
import 'package:bangapp/providers/friends_provider.dart';
import 'package:bangapp/providers/image_upload.dart';
import 'package:bangapp/providers/inprirations_Provider.dart';
import 'package:bangapp/providers/insights_provider.dart';
import 'package:bangapp/providers/message_payment_provider.dart';
import 'package:bangapp/providers/notification_provider.dart';
import 'package:bangapp/providers/payment_provider.dart';
import 'package:bangapp/providers/post_likes.dart';
import 'package:bangapp/providers/posts_provider.dart';
import 'package:bangapp/providers/subscription_payment_provider.dart';
import 'package:bangapp/providers/update_comment_provider.dart';
import 'package:bangapp/providers/update_video_upload.dart';
import 'package:bangapp/providers/video_upload.dart';
import 'package:bangapp/screens/Activity/activity_page.dart';
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
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:bangapp/screens/Create/video_editing/video_edit.dart';
import 'firebase_options.dart';
import 'package:bangapp/providers/user_provider.dart';
import 'screens/Authenticate/welcome_screen.dart';
import 'screens/Profile/edit_profile.dart';
import 'screens/Authenticate/register_screen.dart';
import 'screens/Chat/chat_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bangapp/screens/Create/final_create.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bangapp/services/service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

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
    ChangeNotifierProvider(create: (context) => VideoUploadProvider()),
    ChangeNotifierProvider(create: (context) => ImageUploadProvider()),
    ChangeNotifierProvider(create: (context) => PaymentProvider()),
    ChangeNotifierProvider(create: (context) => ChallengeUploadProvider()),
    ChangeNotifierProvider(create: (context) => ChallengeUploadProvider()),
    ChangeNotifierProvider(create: (context) => UpdateCommentProvider()),
    ChangeNotifierProvider(create: (context) => BattleCommentProvider()),
    ChangeNotifierProvider(create: (context) => MessagePaymentProvider()),
    ChangeNotifierProvider(create: (context) => SubscriptionPaymentProvider()),
    ChangeNotifierProvider(create: (context) => InsightProvider()),
    ChangeNotifierProvider(create: (context) => UpdateVideoUploadProvider()),
    ChangeNotifierProvider(create: (context) => FollowerProvider()),
    ChangeNotifierProvider(create: (context) => FriendProvider()),
    ChangeNotifierProvider(create: (context) => NotificationProvider()),
    ChangeNotifierProvider(create: (context) => UpdateImageUploadProvider()),
    ChangeNotifierProvider(create: (context) => CreatePostProvider()),

  ], child: MyApp()));
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Authenticate.id,
      routes: {
        '/login': (context) => LoginScreen(),
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

// For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) {
      final firstSharedFile = value.isNotEmpty ? value[0] : null;

      if (firstSharedFile != null) {
        final filePath = firstSharedFile.path;

        if (value.length == 1) {
          // Single file
          print('single file');
          if (filePath.toLowerCase().endsWith('.jpg') ||
              filePath.toLowerCase().endsWith('.png')) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ImageEditor(
                  image: fileToUint8List(File(filePath)),
                  allowMultiple: false,
                ),
              ),
            );
          } else if (filePath.toLowerCase().endsWith('.mp4') ||
              filePath.toLowerCase().endsWith('.avi')) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VideoEditor(
                  video: File(filePath),
                ),
              ),
            );
          } else {
            print('Unsupported file type: $filePath');
          }
        } else if (value.length >= 2) {
          // Multiple files

          if (value.every((file) =>
              file.path.toLowerCase().endsWith('.jpg') ||
              file.path.toLowerCase().endsWith('.png'))) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ImageEditor(
                  image: fileToUint8List(File(filePath)),
                  image2: fileToUint8List(File(value[1].path)),
                  allowMultiple: true,
                ),
              ),
            );
          } else if (value.every((file) =>
              file.path.toLowerCase().endsWith('.mp4') ||
              file.path.toLowerCase().endsWith('.avi'))) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VideoEditor(
                  video: File(filePath),
                  video2: File(value[1].path),
                ),
              ),
            );
          } else {
            print('Unsupported file type for multiple selection');
          }
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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(message.data["type"]);
      print('notification type');
      // Handle incoming messages when the app is in the foreground.
      String? title = message.notification?.title;
      String? body = message.notification?.body;

      if (message.data["type"] == "message") {
        int notificationId = int.parse(message.data['notification_id']);
        String? userName = message.data['user_name'];
        print(
            "THis is of object type ${notificationId.runtimeType} and is $notificationId user is $userName");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagesScreen(
                notificationId,
                message.data['user_name'] ?? "Username",
                logoUrl,
                false,
                0,
                "0"),
          ),
        );
      }
      if (message.data["type"] == "like") {
        int notificationId = int.parse(message.data['notification_id']);
        String? userName = message.data['user_name'];

        var postData =
            await Service().getPostInfo(message.data['notification_id']);
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
                postData[0]['created_at'] ?? '',
                postData[0]['user_image_url'],
                postData[0]['pinned'],
                postData[0]['cache_url'],
                postData[0]['thumbnail_url'],
                postData[0]['aspect_ratio'],
                postData[0]['price'],
                postData[0]['post_views_count'],
                Provider.of<ProfileProvider>(context, listen: false)),
          ),
        );
      }
      if (message.data["type"] == "comment")
      {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NotificationCommentsPage(userId: message.data['user_id'], postId: message.data['notification_id'])
            )
        );
      }
      if(message.data["type"] == "friend"){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Nav(initialIndex: 3)
            )
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
      if (title != null && body != null) {
        _showLocalNotification(title, body);
      } else {
        print('Received message with missing title or body.');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('notification type');
      print(message.data["type"]);
      print(message.data["type"] == "message");

      if (message.data["type"] == "message") {
        int notificationId = int.parse(message.data['notification_id']);
        String? userName = message.data['user_name'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagesScreen(
                notificationId, userName ?? "Username", logoUrl, false, 0, "0"),
          ),
        );
      }

      if (message.data["type"] == "like") {
        int notificationId = int.parse(message.data['notification_id']);
        String? userName = message.data['user_name'];

        var postData =
            await Service().getPostInfo(message.data['notification_id']);
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
                postData[0]['created_at'] ?? '',
                postData[0]['user_image_url'],
                postData[0]['pinned'],
                postData[0]['cache_url'],
                postData[0]['thumbnail_url'],
                postData[0]['aspect_ratio'],
                postData[0]['price'],
                postData[0]['post_views_count'],
                Provider.of<ProfileProvider>(context, listen: false)),
          ),
        );
      }
      if (message.data["type"] == "comment")
      {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NotificationCommentsPage(userId: message.data['user_id'], postId: message.data['notification_id'])
            )
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

      if(message.data["type"] == "friend"){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Nav(initialIndex: 3)
            )
        );
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return FutureBuilder<Map<String, dynamic>>(
      future: userProvider.readUserDataFromFile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: SplashAnimation());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, dynamic>? userData = snapshot.data;
          if (userData != null && userData.containsKey('device_token')) {
            String token = userData['device_token'];
            if (token.isNotEmpty) {
              return Nav(initialIndex: 0);
            }
          }
          return Welcome();
        }
      },
    );
  }
}
