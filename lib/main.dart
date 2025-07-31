import 'package:calm/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

Future<void> main() async {
  runApp(const CalmApp());
  
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  // await FirestoreService().seedSleepAndMeditationAlbums();
  WidgetsFlutterBinding.ensureInitialized();
}

class CalmApp extends StatelessWidget {
  const CalmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}