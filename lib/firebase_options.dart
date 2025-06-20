// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCb3qsirmxePYAeLbN2DRsv97nI873j_qU',
    appId: '1:487399717017:web:4038eeab304391720ae008',
    messagingSenderId: '487399717017',
    projectId: 'novatech-chat',
    authDomain: 'novatech-chat.firebaseapp.com',
    storageBucket: 'novatech-chat.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCrwWeoP0tY-4JTcVyk-rEGEM6jK_s-gx4',
    appId: '1:487399717017:android:c0d150f511312d5b0ae008',
    messagingSenderId: '487399717017',
    projectId: 'novatech-chat',
    storageBucket: 'novatech-chat.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC6HH2RjZTRfnxXZ2APd398MWe0yUmDOnI',
    appId: '1:487399717017:ios:6f61703af14f7f4c0ae008',
    messagingSenderId: '487399717017',
    projectId: 'novatech-chat',
    storageBucket: 'novatech-chat.firebasestorage.app',
    iosBundleId: 'com.enzoftware.novatech.chat.novatech-chat',
  );
}
