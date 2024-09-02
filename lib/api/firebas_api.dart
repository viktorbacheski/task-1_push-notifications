import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  // instance of firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async {

    // request premission from user
    await _firebaseMessaging.requestPermission();

    // fetch the FCM tokenfor this device
    final fCMToken = await _firebaseMessaging.getToken();

    // print the token
    print('Token $fCMToken');
  }
}