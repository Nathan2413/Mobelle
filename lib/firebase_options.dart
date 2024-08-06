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
    apiKey: 'AIzaSyCswDlIiXXYaKmhkT6CS0mF4NB2A8rNFSI',
    appId: '1:656682489119:web:0b7acbc7fa921361df4c2a',
    messagingSenderId: '656682489119',
    projectId: 'mobelle-e1322',
    authDomain: 'mobelle-e1322.firebaseapp.com',
    databaseURL: 'https://mobelle-e1322-default-rtdb.firebaseio.com',
    storageBucket: 'mobelle-e1322.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDWW4iRdyvyPhsi3Fv91T-0MWGcY5N7kJg',
    appId: '1:656682489119:android:4f432875f4cc2965df4c2a',
    messagingSenderId: '656682489119',
    projectId: 'mobelle-e1322',
    databaseURL: 'https://mobelle-e1322-default-rtdb.firebaseio.com',
    storageBucket: 'mobelle-e1322.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD8KSK8ac8VMzEItNINKQ_AIOK5rQe9kXE',
    appId: '1:656682489119:ios:99c42a40961fe772df4c2a',
    messagingSenderId: '656682489119',
    projectId: 'mobelle-e1322',
    databaseURL: 'https://mobelle-e1322-default-rtdb.firebaseio.com',
    storageBucket: 'mobelle-e1322.appspot.com',
    iosBundleId: 'com.example.moBelle',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD8KSK8ac8VMzEItNINKQ_AIOK5rQe9kXE',
    appId: '1:656682489119:ios:99c42a40961fe772df4c2a',
    messagingSenderId: '656682489119',
    projectId: 'mobelle-e1322',
    databaseURL: 'https://mobelle-e1322-default-rtdb.firebaseio.com',
    storageBucket: 'mobelle-e1322.appspot.com',
    iosBundleId: 'com.example.moBelle',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCswDlIiXXYaKmhkT6CS0mF4NB2A8rNFSI',
    appId: '1:656682489119:web:0b7acbc7fa921361df4c2a',
    messagingSenderId: '656682489119',
    projectId: 'mobelle-e1322',
    authDomain: 'mobelle-e1322.firebaseapp.com',
    databaseURL: 'https://mobelle-e1322-default-rtdb.firebaseio.com',
    storageBucket: 'mobelle-e1322.appspot.com',
  );

}