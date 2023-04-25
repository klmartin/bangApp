import 'package:flutter/material.dart';
import 'package:nallagram/nav.dart';
import 'package:nallagram/screens/Authenticate/login_screen.dart';
import 'package:nallagram/screens/Chat/calls_chat.dart';
import 'package:nallagram/screens/Chat/new_message_chat.dart';
import 'package:provider/provider.dart';
import 'models/userprovider.dart';
import 'screens/Authenticate/welcome_screen.dart';
import 'screens/Profile/edit_profile.dart';
import 'screens/Authenticate/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'root.dart';
import 'screens/Chat/chat_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      MultiProvider(providers: [
          ChangeNotifierProvider(create: (_) => UserProvider())],
      child:MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationProvider>(
            create: (_) => AuthenticationProvider(FirebaseAuth.instance)),
        StreamProvider(
            create: (context) =>
                context.read<AuthenticationProvider>().authStateChanges)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Authenticate.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          // ChatScreen.id: (context) => ChatScreen(),
          NewMessageChat.id: (context) => NewMessageChat(),
          ChatHome.id: (context) => ChatHome(),
          CallsChat.id: (context) => CallsChat(),
          Nav.id: (context) => Nav(),
          Register.id: (context) => Register(),
          Welcome.id: (context) => Welcome(),
          EditPage.id:(context) => EditPage(),
          Authenticate.id: (context) => Authenticate(),
        },
      ),
    );
  }
}

class Authenticate extends StatelessWidget {
  static const id = 'auth';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String token = snapshot.data.getString('token');
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