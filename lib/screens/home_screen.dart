import 'package:calm/firestore_service.dart';
import 'package:calm/screens/bar_music.dart';
import 'package:calm/screens/calm_detail.dart';
import 'package:calm/screens/daily_calm_detail.dart';
import 'package:calm/screens/favorite_screen.dart';
import 'package:calm/screens/meditate_screen.dart';
import 'package:calm/screens/music_player_screen.dart';
import 'package:calm/screens/music_screen.dart';
import 'package:calm/screens/profile_screen.dart';
import 'package:calm/screens/sleep_screen.dart';
import 'package:calm/util.dart';
import 'package:flutter/material.dart';
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
      HomePage(onSelected: (String title) { 
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
        } else
        if (title == 'Sleep') {
          setState(() {
            currentIndex = 1; // SleepScreen
          });
        } else if (title == 'Meditate') {
          setState(() {
            currentIndex = 2; // MeditateScreen
          });
        } else if (title == 'Music') {
          setState(() {
            currentIndex = 3; // MusicScreen
          });
        }
       },),
      SleepScreen(onTrackSelected: playTrack),
      MeditateScreen(onTrackSelected: playTrack),
      MusicScreen(onTrackSelected: playTrack),
      ProfileScreen(),
    ];
    super.initState();
  }

  Future<void> playTrack(String title, String author, String audio, String imageUrl) async {
    // play the audio track here

    await AudioManager.audioPlayer.setUrl(audio); // hoặc file cục bộ
    AudioManager.audioPlayer.play();

    setState(() {
      currentTrackTitle = title;
      currentTrackAuthor = author;
      currentTrackAudio = audio;
      currentTrackImageUrl = imageUrl;
      
      isPlaying = true;
    });
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
        title: const Text(
          'Hello, User',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),  centerTitle: false,
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

                    AudioManager.audioPlayer.playing ? AudioManager.audioPlayer.pause() : AudioManager.audioPlayer.play();
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
                        builder: (context) => MusicPlayerScreen(
                          title: currentTrackTitle?? '',
                          author: currentTrackAuthor ?? '',
                          imageUrl:currentTrackImageUrl ?? '',
                          audioUrl:currentTrackAudio ?? '',
                        ),
                      ),
                    );
                  }),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
 Function(String title) onSelected;
  HomePage({super.key, required this.onSelected});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        // Background image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://images.unsplash.com/photo-1506744038136-46273834b3fb'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Overlay content
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
        ),
        // Main content
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily Calm',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '7 Days of Calm • 10 min',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DailyCalmDetailScreen()),
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Explore',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                      onTap: () {
                        onSelected('Favourite');
                      },
                      child: CategoryCard(title: 'Favourite', icon: Icons.favorite_border),
                    ),
                    GestureDetector(
                      onTap: () {
                        onSelected('Sleep');
                      },
                      child: CategoryCard(title: 'Sleep', icon: Icons.bedtime),
                    ),
                    GestureDetector(
                      onTap: () {
                       onSelected('Meditate');
                      },
                      child: CategoryCard(
                          title: 'Meditate', icon: Icons.self_improvement),
                    ),
                    GestureDetector(
                      onTap: () {
                         onSelected('Music');
                      },
                      child:
                          CategoryCard(title: 'Music', icon: Icons.music_note),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
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
          Icon(icon, size: 40, color: Colors.black87),
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
