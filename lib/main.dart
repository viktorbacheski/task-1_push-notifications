import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_1_push_notifications/api/firebas_api.dart';
import 'package:task_1_push_notifications/pages/home_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
     debugShowCheckedModeBanner: false,
     home: HomePasge(),
    );
  }
}