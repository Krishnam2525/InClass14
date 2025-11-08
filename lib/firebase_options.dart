import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
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
        return linux;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCvcoy2E91kKbEw1ma2VpDFbPpKv_evBfS',
    appId: '1:310947602727:web:669d91794a13616fe89802',
    messagingSenderId: '310947602727',
    projectId: 'inclass14-63bce',
    authDomain: 'inclass14-63bce.firebaseapp.com',
    storageBucket: 'inclass14-63bce.firebasestorage.app',
    measurementId: 'G-RPTJUSZXQ1',
    databaseURL: 'https://inclass14-63bce-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions android = web;
  static const FirebaseOptions ios = web;
  static const FirebaseOptions macos = web;
  static const FirebaseOptions windows = web;
  static const FirebaseOptions linux = web;
}
