import 'dart:ui';

import 'package:calm/firestore_service.dart';
import 'package:calm/screens/bar_music.dart';
import 'package:calm/screens/calm_detail.dart';
import 'package:calm/screens/daily_calm_detail.dart';
import 'package:calm/screens/favorite_screen.dart';
import 'package:calm/screens/meditate_screen.dart';
import 'package:calm/screens/musicplayer_screen.dart' hide MiniMusicPlayer;
import 'package:calm/screens/relax_screen.dart';
import 'package:calm/screens/profile_screen.dart';
import 'package:calm/screens/yoga_screen.dart';
import 'package:calm/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:just_audio/just_audio.dart';

var pages = [
  // Add other screens here
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  String? currentTrackTitle;
  String? currentTrackAuthor;
  String? currentTrackAudio;
  String? currentTrackImageUrl;
  bool isPlaying = false;

  @override
  void initState() {
    pages = [
      HomePage(
        onSelected: (String title) {
          if (title == 'Favourite') {
            setState(() {
              currentIndex = 0; // HomePage
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FavoriteScreen(),
              ),
            );
          } else if (title == 'Yoga') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FavoriteScreen(),
              ),
            );
          } else if (title == 'Meditation') {
            setState(() {
              currentIndex = 2; // MeditateScreen
            });
          } else if (title == 'Music') {
            setState(() {
              currentIndex = 3; // RelaxScreen
            });
          }
        },
        onTrackSelected: playTrack,
      ),
      YogaScreen(onTrackSelected: playTrack),
      MeditateScreen(onTrackSelected: playTrack),
      RelaxScreen(onTrackSelected: playTrack),
      ProfileScreen(),
    ];
    super.initState();
  }

  Future<void> playTrack(
      String title, String author, String audio, String imageUrl) async {
    // play the audio track here
    context.read<PlayerController>().playTrack(
          title: title,
          author: author,
          imageUrl: imageUrl,
          audioUrl: audio,
        );

    await AudioManager.audioPlayer.setUrl(audio); // hoặc file cục bộ
    AudioManager.audioPlayer.play();

    // setState(() {
    //   currentTrackTitle = title;
    //   currentTrackAuthor = author;
    //   currentTrackAudio = audio;
    //   currentTrackImageUrl = imageUrl;

    //   isPlaying = true;
    // });
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // title: const Text(
        //   'Hello, User',
        //   style: TextStyle(
        //     fontSize: 24,
        //     fontWeight: FontWeight.bold,
        //     color: Colors.white,
        //   ),
        // ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          pages[currentIndex],
          if (currentTrackTitle != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: MiniMusicPlayer(
                  title: currentTrackTitle!,
                  author: currentTrackAuthor ?? '',
                  isPlaying: isPlaying,
                  onPlayPause: () {
                    AudioManager.audioPlayer.playing
                        ? AudioManager.audioPlayer.pause()
                        : AudioManager.audioPlayer.play();
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  },
                  onClose: () {
                    AudioManager.audioPlayer.stop();
                    setState(() {
                      currentTrackTitle = null;
                      currentTrackAuthor = null;
                      isPlaying = false;
                    });
                  },
                  onFullScreen: () {
                    // // Navigate to the full music player screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RelaxScreen(onTrackSelected: playTrack)),
                    );
                  }),
            ),
        ],
      ),
      // bottomNavigationBar: BottomNavBar(
      //   currentIndex: currentIndex,
      //   onTap: onTabTapped,
      // ),
    );
  }
}

class HomePage extends StatelessWidget {
  Function(String title) onSelected;
  final Function(String title, String author, String audio, String imageUrl)
      onTrackSelected;
  HomePage(
      {super.key, required this.onSelected, required this.onTrackSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background
          Image.asset(
            'assets/forest.jpg',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          /// Blur background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2F3E34),
                    Color(0xFF9FAF90), // giữa
                    Color(0xFFDDE5A0), // trên
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          /// Main Card
          SingleChildScrollView(
            child: Center(
              child: Container(
                height: 2000,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFDEE5D0).withOpacity(0.85),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 16),
                    _quoteCard(),
                    const SizedBox(height: 20),
                    _featureGrid(),
                    const SizedBox(height: 20),
                    _newFeatures(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
Widget _header() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Good morning, Alex",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _MoodItem(
            icon: Icons.sentiment_satisfied,
            label: "Happy",
            mood: Mood.happy,
          ),
          _MoodItem(
            icon: Icons.self_improvement,
            label: "Calm",
            mood: Mood.calm,
          ),
          _MoodItem(
            icon: Icons.sentiment_neutral,
            label: "Confused",
            mood: Mood.confused,
          ),
          _MoodItem(
            icon: Icons.sentiment_dissatisfied,
            label: "Sad",
            mood: Mood.sad,
          ),
          _MoodItem(
            icon: Icons.favorite_border,
            label: "Loving",
            mood: Mood.loving,
          ),
        ],
      )
    ],
  );
}

  /// QUOTE
  Widget _quoteCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Text(
          "“Peace begins with a smile.”",
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  /// GRID
  Widget _featureGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _CircleButton(
          icon: Icons.self_improvement,
          label: "Yoga",
          onTrackSelected: onTrackSelected,
        ),
        _CircleButton(
            icon: Icons.spa,
            label: "Meditation",
            onTrackSelected: onTrackSelected),
        _CircleButton(
            icon: Icons.weekend,
            label: "Relax",
            onTrackSelected: onTrackSelected),
        _CircleButton(
            icon: Icons.air,
            label: "Breathing",
            onTrackSelected: onTrackSelected),
      ],
    );
  }

  /// NEW FEATURES
  Widget _newFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "New Features",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _MiniFeature(icon: Icons.music_note, label: "Sounds"),
            _MiniFeature(icon: Icons.local_florist, label: "Soul Garden"),
            _MiniFeature(icon: Icons.edit_note, label: "Stress Diary"),
          ],
        )
      ],
    );
  }

  /// MUSIC PLAYER
  Widget _musicPlayer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          Icon(Icons.waves),
          SizedBox(width: 8),
          Text("Ocean Waves"),
          Spacer(),
          Icon(Icons.play_arrow),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final Function(String title, String author, String audio, String imageUrl)
      onTrackSelected;
  final IconData icon;
  final String label;

  const _CircleButton(
      {required this.icon, required this.label, required this.onTrackSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: GestureDetector(
          onTap: () {
            if (label == 'Favourite') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteScreen(),
                ),
              );
            } else if (label == 'Yoga') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        YogaScreen(onTrackSelected: onTrackSelected),
                  ));
            } else if (label == 'Meditation') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeditateScreen(
                    onTrackSelected: onTrackSelected,
                  ),
                ),
              );
            } else if (label == 'Relax') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RelaxScreen(onTrackSelected: onTrackSelected),
                ),
              );
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28),
              const SizedBox(height: 8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniFeature extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MiniFeature({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const CategoryCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Color(0xFFDDE5A0)),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}


enum Mood {
  happy,
  calm,
  confused,
  sad,
  loving,
}
class MoodController extends ChangeNotifier {
  Mood? _selectedMood;

  Mood? get selectedMood => _selectedMood;

  void selectMood(Mood mood) {
    _selectedMood = mood;
    notifyListeners();
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

