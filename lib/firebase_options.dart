// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'

    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBsqXQoaX6aceHhauD5sWFsD7YTzpVs3lo',
    appId: '1:515952068275:android:0229382cc44014db5c12c6',
    messagingSenderId: '515952068275',
    projectId: 'bangappp-3f9ec',
    databaseURL: 'https://bangappp-3f9ec-default-rtdb.firebaseio.com',
    storageBucket: 'bangappp-3f9ec.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAxDL8urdRL3wEOmr_e54xlzGuJCwBtLVA',
    appId: '1:515952068275:ios:ce83177f9706290a5c12c6',
    messagingSenderId: '515952068275',
    projectId: 'bangappp-3f9ec',
    databaseURL: 'https://bangappp-3f9ec-default-rtdb.firebaseio.com',
    storageBucket: 'bangappp-3f9ec.appspot.com',
    androidClientId: '515952068275-p8n4jkhbtc3d8103t63gvuvm52r16re3.apps.googleusercontent.com',
    iosClientId: '515952068275-993ca05akfgi392br8br7ggbn7be1cnn.apps.googleusercontent.com',
    iosBundleId: 'com.cyblogerz.bangapp',
  );
}
