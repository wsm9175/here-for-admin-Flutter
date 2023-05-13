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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBbXVIMkZC-qzU9-GZT2OYUVUN9GILM6lc',
    appId: '1:602279951968:android:1cc5c29bcc66430c420d05',
    messagingSenderId: '602279951968',
    projectId: 'here-flutter',
    databaseURL: 'https://here-flutter-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'here-flutter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCpFatGLoioZHosZHFwYADtsvT5gUg5kw8',
    appId: '1:602279951968:ios:25b8e606e4b6445e420d05',
    messagingSenderId: '602279951968',
    projectId: 'here-flutter',
    databaseURL: 'https://here-flutter-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'here-flutter.appspot.com',
    androidClientId: '602279951968-14a8ri47u3lnr7oprh4h878o3ioa82us.apps.googleusercontent.com',
    iosClientId: '602279951968-5vkql57ihr7h4pgh8ihoc4ahmq8iml78.apps.googleusercontent.com',
    iosBundleId: 'com.wsm9175.flutter.hereAdmin',
  );
}