// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDpg6SmR9RWqYMvw9tK5m6cNZkZ_i3Ailg',
    appId: '1:232820575001:web:406eb90bfe323c3eedd388',
    messagingSenderId: '232820575001',
    projectId: 'chat-app-6df6f',
    authDomain: 'chat-app-6df6f.firebaseapp.com',
    storageBucket: 'chat-app-6df6f.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAqNzJxWe7UYluH2gEtbyuvD68I8_6EWTA',
    appId: '1:232820575001:android:6568366bf0249346edd388',
    messagingSenderId: '232820575001',
    projectId: 'chat-app-6df6f',
    storageBucket: 'chat-app-6df6f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCU0Ybj25IzmPMqCPIoCgaD0njGtm3KwcI',
    appId: '1:232820575001:ios:52ac382954370e61edd388',
    messagingSenderId: '232820575001',
    projectId: 'chat-app-6df6f',
    storageBucket: 'chat-app-6df6f.appspot.com',
    iosClientId: '232820575001-kb2il971vq77pf80f472ekd3og7r84cu.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp',
  );
}
