import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyApPemcSlB3rXuBFaJHzstSv7Vft6hqq3A',
    appId: '1:744055192075:web:deeee4c752efb1f361a50e',
    messagingSenderId: '744055192075',
    projectId: 'quickbasket-87f7c',
    authDomain: 'quickbasket-87f7c.firebaseapp.com',
    storageBucket: 'quickbasket-87f7c.firebasestorage.app',
    measurementId: 'G-E0RD9V7R1L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9r8X5D7FCyeTQ1UmLeVEy5BNJvpokwd0',
    appId: '1:744055192075:android:b389c7d9f6d1b40261a50e',
    messagingSenderId: '744055192075',
    projectId: 'quickbasket-87f7c',
    storageBucket: 'quickbasket-87f7c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC6pA1InZhLKIPN6o3PytrNYGdfNm0PCEQ',
    appId: '1:744055192075:ios:f623afafb008875961a50e',
    messagingSenderId: '744055192075',
    projectId: 'quickbasket-87f7c',
    storageBucket: 'quickbasket-87f7c.firebasestorage.app',
    iosBundleId: 'com.example.quickbasket',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC6pA1InZhLKIPN6o3PytrNYGdfNm0PCEQ',
    appId: '1:744055192075:ios:f623afafb008875961a50e',
    messagingSenderId: '744055192075',
    projectId: 'quickbasket-87f7c',
    storageBucket: 'quickbasket-87f7c.firebasestorage.app',
    iosBundleId: 'com.example.quickbasket',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyApPemcSlB3rXuBFaJHzstSv7Vft6hqq3A',
    appId: '1:744055192075:web:429e69f3d517654361a50e',
    messagingSenderId: '744055192075',
    projectId: 'quickbasket-87f7c',
    authDomain: 'quickbasket-87f7c.firebaseapp.com',
    storageBucket: 'quickbasket-87f7c.firebasestorage.app',
    measurementId: 'G-DZMW1NL0VY',
  );
}
