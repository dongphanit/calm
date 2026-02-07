import 'package:calm/firestore_service.dart';
import 'package:calm/screens/home_screen.dart';
import 'package:calm/screens/musicplayer_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

Future<void> main() async {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PlayerController(),
      child: CalmApp(),
    ),
  );

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
      home: const AppShell(),
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Navigator riêng cho toàn bộ app pages
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (_) => const SplashScreen(),
              );
            },
          ),

          // Mini Player overlay cố định
          Align(
            alignment: Alignment.bottomCenter,
            child: MiniMusicPlayer(),
          ),
        ],
      ),
    );
  }
}
