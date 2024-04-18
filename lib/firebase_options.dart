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
    apiKey: 'AIzaSyBlA5NRqrIB946F2YQA7Z1GnicP4fXx5ss',
    appId: '1:273341162455:web:99aa84f8853c9fd0296192',
    messagingSenderId: '273341162455',
    projectId: 'term-project-edgar-burgess',
    authDomain: 'term-project-edgar-burgess.firebaseapp.com',
    storageBucket: 'term-project-edgar-burgess.appspot.com',
    measurementId: 'G-7Q1KWY2MF7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCtXx-jiADH_eInVges-_h3axiJh9D5Ij0',
    appId: '1:273341162455:android:839f445b5d3402fc296192',
    messagingSenderId: '273341162455',
    projectId: 'term-project-edgar-burgess',
    storageBucket: 'term-project-edgar-burgess.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD-2tdhktCQZX84vVCEh2D-iHbAlGYujZI',
    appId: '1:273341162455:ios:f2117836f8f22218296192',
    messagingSenderId: '273341162455',
    projectId: 'term-project-edgar-burgess',
    storageBucket: 'term-project-edgar-burgess.appspot.com',
    iosBundleId: 'com.example.csc315TeamEdgarBurgessProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD-2tdhktCQZX84vVCEh2D-iHbAlGYujZI',
    appId: '1:273341162455:ios:f2117836f8f22218296192',
    messagingSenderId: '273341162455',
    projectId: 'term-project-edgar-burgess',
    storageBucket: 'term-project-edgar-burgess.appspot.com',
    iosBundleId: 'com.example.csc315TeamEdgarBurgessProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBlA5NRqrIB946F2YQA7Z1GnicP4fXx5ss',
    appId: '1:273341162455:web:e7e0d6420587860b296192',
    messagingSenderId: '273341162455',
    projectId: 'term-project-edgar-burgess',
    authDomain: 'term-project-edgar-burgess.firebaseapp.com',
    storageBucket: 'term-project-edgar-burgess.appspot.com',
    measurementId: 'G-QW73XXZYLV',
  );

}