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
    apiKey: 'AIzaSyBy71E9LPf0XOhzwXZezzZV-oDd68CkpDg',
    appId: '1:706892114240:web:97782857a7348af97cf2a5',
    messagingSenderId: '706892114240',
    projectId: 'new-firebase-setup-e0f49',
    authDomain: 'new-firebase-setup-e0f49.firebaseapp.com',
    storageBucket: 'new-firebase-setup-e0f49.appspot.com',
    measurementId: 'G-VLYH171DNZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBc-Uh6f8uA9Ag3BXQwdmmR2AkXCUYKAGo',
    appId: '1:706892114240:android:f99b17be66c0a03d7cf2a5',
    messagingSenderId: '706892114240',
    projectId: 'new-firebase-setup-e0f49',
    storageBucket: 'new-firebase-setup-e0f49.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDfKBLI-1mBp1mb2Isrvb2j_Txb_Xn8mQs',
    appId: '1:706892114240:ios:d1839028af72ec9c7cf2a5',
    messagingSenderId: '706892114240',
    projectId: 'new-firebase-setup-e0f49',
    storageBucket: 'new-firebase-setup-e0f49.appspot.com',
    iosBundleId: 'com.example.driverBuddies',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDfKBLI-1mBp1mb2Isrvb2j_Txb_Xn8mQs',
    appId: '1:706892114240:ios:650011ac707ad6e97cf2a5',
    messagingSenderId: '706892114240',
    projectId: 'new-firebase-setup-e0f49',
    storageBucket: 'new-firebase-setup-e0f49.appspot.com',
    iosBundleId: 'com.example.driverBuddies.RunnerTests',
  );
}
