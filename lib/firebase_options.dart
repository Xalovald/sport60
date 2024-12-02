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
    apiKey: 'AIzaSyBRYEzyXZX1l_NA75QnED5365nFATWBxKs',
    appId: '1:465782468893:web:95f0912676d3f75fe931f4',
    messagingSenderId: '465782468893',
    projectId: 'sport60-db9b8',
    authDomain: 'sport60-db9b8.firebaseapp.com',
    storageBucket: 'sport60-db9b8.firebasestorage.app',
    measurementId: 'G-P04GP2FJLB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBi2z0ucAfekNaBG8bAcn1qrGV1PSRwarI',
    appId: '1:465782468893:android:c94b6bad4630ebe4e931f4',
    messagingSenderId: '465782468893',
    projectId: 'sport60-db9b8',
    storageBucket: 'sport60-db9b8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyClKXWa36GM0EwoQ2Y1CLeuIEDZDLn7EBY',
    appId: '1:465782468893:ios:d0a13f31e054f1d3e931f4',
    messagingSenderId: '465782468893',
    projectId: 'sport60-db9b8',
    storageBucket: 'sport60-db9b8.firebasestorage.app',
    androidClientId: '465782468893-rrd69dibg9gfanbrvah9o6nfb337hdis.apps.googleusercontent.com',
    iosClientId: '465782468893-1do2gr7tg0melh7u2vvjcmmq13rajruc.apps.googleusercontent.com',
    iosBundleId: 'com.example.sport60',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyClKXWa36GM0EwoQ2Y1CLeuIEDZDLn7EBY',
    appId: '1:465782468893:ios:d0a13f31e054f1d3e931f4',
    messagingSenderId: '465782468893',
    projectId: 'sport60-db9b8',
    storageBucket: 'sport60-db9b8.firebasestorage.app',
    androidClientId: '465782468893-rrd69dibg9gfanbrvah9o6nfb337hdis.apps.googleusercontent.com',
    iosClientId: '465782468893-1do2gr7tg0melh7u2vvjcmmq13rajruc.apps.googleusercontent.com',
    iosBundleId: 'com.example.sport60',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBRYEzyXZX1l_NA75QnED5365nFATWBxKs',
    appId: '1:465782468893:web:97c666709b9b9e69e931f4',
    messagingSenderId: '465782468893',
    projectId: 'sport60-db9b8',
    authDomain: 'sport60-db9b8.firebaseapp.com',
    storageBucket: 'sport60-db9b8.firebasestorage.app',
    measurementId: 'G-9TD5WRB43H',
  );
}
