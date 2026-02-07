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
      child:MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => MoodController()),
  ],
  child:  CalmApp(),
)

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
        scaffoldBackgroundColor: Color(0xFFDDE5A0),
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

class _MoodItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Mood mood;

  const _MoodItem({
    required this.icon,
    required this.label,
    required this.mood,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MoodController>();
    final isSelected = controller.selectedMood == mood;

    return GestureDetector(
      onTap: () {
        context.read<MoodController>().selectMood(mood);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
