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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDq7ufNt5W8HSLaGJHYQMgqgPPa1QWreAY',
    appId: '1:315086935227:android:9b48a09be3e2022246859e',
    messagingSenderId: '315086935227',
    projectId: 'app-hyperfit',
    storageBucket: 'app-hyperfit.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBJbIlupa90TBy7TtVYw-v50xGdmCnbj5g',
    appId: '1:315086935227:ios:90f3e2dcfa77264946859e',
    messagingSenderId: '315086935227',
    projectId: 'app-hyperfit',
    storageBucket: 'app-hyperfit.appspot.com',
    iosBundleId: 'com.example.flutterHyperfit',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA1GONQieQJxZNNeJisSa5CDK-QThP_hVM',
    appId: '1:1046442950323:web:48f59268264e20db98bac6',
    messagingSenderId: '1046442950323',
    projectId: 'hyperfit-proyect-bcd75',
    authDomain: 'hyperfit-proyect-bcd75.firebaseapp.com',
    storageBucket: 'hyperfit-proyect-bcd75.appspot.com',
  );
}