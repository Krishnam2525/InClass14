import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return web;
      case TargetPlatform.iOS:
        return web;
      case TargetPlatform.macOS:
        return web;
      case TargetPlatform.windows:
        return web;
      case TargetPlatform.linux:
        return web;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCVCv20j1XdEkmVma2VbPFoPbxR_eVbEfs',
    appId: '1:310947602727:web:609d19f34a13616fe88902',
    messagingSenderId: '310947602727',
    projectId: 'inclass14-63bce',
    authDomain: 'inclass14-63bce.firebaseapp.com',
    storageBucket: 'inclass14-63bce.firebasestorage.app',
    measurementId: 'G-RPTJTSZXQ1',
    databaseURL: 'https://inclass14-63bce-default-rtdb.firebaseio.com',
  );
}
