import 'dart:convert';
import 'dart:ui';
import 'package:calm/screens/relax_screen.dart';
import 'package:calm/util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerController extends ChangeNotifier {
  String title = '';
  String author = '';
  String imageUrl = '';
  String audioUrl = '';
  bool isPlaying = false;

  void playTrack({
    required String title,
    required String author,
    required String imageUrl,
    required String audioUrl,
  }) {
    this.title = title;
    this.author = author;
    this.imageUrl = imageUrl;
    this.audioUrl = audioUrl;
    isPlaying = true;
    notifyListeners();
  }

  void togglePlay() {
    isPlaying = !isPlaying;
    notifyListeners();
    if (isPlaying) {
      AudioManager.audioPlayer.play();
    } else {
      AudioManager.audioPlayer.pause();
    }
  }

  void stop() {
    // audioPlayer.stop(); // nếu có audio player
    isPlaying = false;
    title = '';
    author = '';
    notifyListeners();
    AudioManager.audioPlayer.stop();
  }
}

class MiniMusicPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerController>(
      builder: (context, player, _) {
        if (player.title.isEmpty) return SizedBox(); // chưa phát gì → ẩn

        return Container(
          height: 70,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Color(0xFFDDE5A0),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.music_note, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(player.title,
                        style: const TextStyle(color: Colors.white)),
                    Text(player.author,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<PlayerController>().togglePlay();
                },
                icon: Icon(
                  player.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MusicPlayerScreen(
                          title: player.title,
                          author: player.author,
                          audioUrl: player.audioUrl,
                          imageUrl: player.imageUrl,
                        ),
                      ));
                },
                icon:
                    const Icon(Icons.fullscreen, color: Colors.white, size: 32),
              ),
              SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  context.read<PlayerController>().stop();
                },
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  final String title;
  final String author;
  final String imageUrl;
  final String audioUrl;

  const MusicPlayerScreen({
    super.key,
    required this.title,
    required this.author,
    required this.audioUrl,
    required this.imageUrl,
  });

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen>
    with TickerProviderStateMixin {
  bool isPlaying = false;
  double progress = 0.0;
  late AnimationController _rotationController;
  List<Map<String, String>> favoriteSongs = [];

  bool isFavorite = false;

  // Progress value between 0.0 and 1.0
  // You can replace this with a more complex logic to track the actual audio progress
  @override
  void initState() {
    super.initState();

    // Initialize the rotation controller
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    // Start the rotation animation
    _rotationController.repeat();

    AudioManager.audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        _rotationController.repeat(); // bắt đầu xoay
      } else {
        _rotationController.stop(); // dừng xoay
      }

      setState(() {
        isPlaying = state.playing;
      });
    });

    AudioManager.audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        setState(() {
          isPlaying = true;
          progress = AudioManager.audioPlayer.position.inSeconds /
              AudioManager.audioPlayer.duration!.inSeconds;
        });
      } else if (state.processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = false;
        });
      }
    });
    // TODO: implement initState
    super.initState();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> loadFavorites(String currentTitle) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteStrings = prefs.getStringList('favoriteSongs') ?? [];

    favoriteSongs = favoriteStrings
        .map((item) => Map<String, String>.from(jsonDecode(item)))
        .toList();

    setState(() {
      isFavorite = favoriteSongs.any((song) => song['title'] == currentTitle);
    });
  }

  Future<void> toggleFavorite({
    required String title,
    required String author,
    required String imageUrl,
    required String audioUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final songData = {
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
    };

    final songString = jsonEncode(songData);

    List<String> favorites = prefs.getStringList('favoriteSongs') ?? [];

    setState(() {
      if (favorites.contains(songString)) {
        favorites.remove(songString);
        isFavorite = false;
      } else {
        favorites.add(songString);
        isFavorite = true;
      }
    });

    await prefs.setStringList('favoriteSongs', favorites);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_outline,
                color: Colors.white),
            onPressed: () {
              toggleFavorite(
                title: widget.title,
                author: widget.author,
                imageUrl: widget.imageUrl,
                audioUrl: widget.audioUrl,
              );

              // Add your favorite logic here
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          /// Background image
          Positioned.fill(
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 32),
          AnimatedBuilder(
            animation: _rotationController,
            builder: (_, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * 3.1416,
                child: child,
              );
            },
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white30, width: 4),
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          /// Blur effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(color: Color(0xFFDDE5A0).withOpacity(0.5)),
            ),
          ),

          /// Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Title & author
                  Column(
                    children: [
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.author,
                        style: GoogleFonts.openSans(
                          color: Colors.white70,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),

                  /// Spacer
                  const SizedBox(height: 40),
                  StreamBuilder<Duration>(
                    stream: AudioManager.audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration = AudioManager.audioPlayer.duration ??
                          Duration(seconds: 1);
                      final progress = position.inMilliseconds /
                          duration.inMilliseconds.clamp(1, double.infinity);

                      /// Progress bar
                      return Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 3,
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6),
                            ),
                            child: Slider(
                              value: progress.clamp(0.0, 1.0),
                              onChanged: (value) {
                                final newPosition = Duration(
                                  milliseconds:
                                      (duration.inMilliseconds * value).toInt(),
                                );
                                AudioManager.audioPlayer.seek(newPosition);
                              },
                              activeColor: Colors.white,
                              inactiveColor: Colors.white24,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(formatDuration(position),
                                    style: TextStyle(color: Colors.white70)),
                                Text(formatDuration(duration),
                                    style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  /// Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.fast_rewind,
                            color: Colors.white, size: 32),
                        onPressed: () {
                          // Add your rewind logic here
                          AudioManager.audioPlayer.seek(
                            AudioManager.audioPlayer.position -
                                Duration(seconds: 10),
                          );
                        },
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: () {
                          setState(() => isPlaying = !isPlaying);
                          if (isPlaying) {
                            AudioManager.audioPlayer.play();
                          } else {
                            AudioManager.audioPlayer.pause();
                          }
                          // Add your play/pause logic here
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFDDE5A0),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 32,
                            color: Color(0xFFDDE5A0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        icon: const Icon(Icons.fast_forward,
                            color: Colors.white, size: 32),
                        onPressed: () {
                          AudioManager.audioPlayer.seek(
                            AudioManager.audioPlayer.position +
                                Duration(seconds: 10),
                          );
                          // Add your fast forward logic here
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
