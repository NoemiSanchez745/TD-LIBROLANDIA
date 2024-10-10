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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyCIfzjvuFj5XGJDt0MsQeMYHb3Er1c-PFk',
    appId: '1:666940457385:web:0bef16c75de5b2526e04b8',
    messagingSenderId: '666940457385',
    projectId: 'db-librolandia',
    authDomain: 'db-librolandia.firebaseapp.com',
    storageBucket: 'db-librolandia.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDhqPj0gEnAE11yg66U9PKn5PM2ZZ5uu7k',
    appId: '1:666940457385:android:4827552c20be00d56e04b8',
    messagingSenderId: '666940457385',
    projectId: 'db-librolandia',
    storageBucket: 'db-librolandia.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAtLLQ3Bg1avWgcrNF5TGjBz1FqlTbAu_w',
    appId: '1:666940457385:ios:14d0c9f6ae9b46cf6e04b8',
    messagingSenderId: '666940457385',
    projectId: 'db-librolandia',
    storageBucket: 'db-librolandia.appspot.com',
    iosBundleId: 'com.example.librolandia001',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAtLLQ3Bg1avWgcrNF5TGjBz1FqlTbAu_w',
    appId: '1:666940457385:ios:14d0c9f6ae9b46cf6e04b8',
    messagingSenderId: '666940457385',
    projectId: 'db-librolandia',
    storageBucket: 'db-librolandia.appspot.com',
    iosBundleId: 'com.example.librolandia001',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCIfzjvuFj5XGJDt0MsQeMYHb3Er1c-PFk',
    appId: '1:666940457385:web:6ad7d72dd4fbd26a6e04b8',
    messagingSenderId: '666940457385',
    projectId: 'db-librolandia',
    authDomain: 'db-librolandia.firebaseapp.com',
    storageBucket: 'db-librolandia.appspot.com',
  );
}