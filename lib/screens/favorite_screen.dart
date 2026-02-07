import 'dart:convert';

import 'package:calm/util.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Map<String, dynamic>> favoriteTracks = [];
  List<String> favoriteTitles = [];
  bool isPlaying = false;
  int? currentIndex;

  @override
  void initState() {
    super.initState();
    AudioManager.audioPlayer.stop(); // Dừng phát nếu đang phát trước đó
    loadFavorites();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteStrings = prefs.getStringList('favoriteSongs') ?? [];

    setState(() {
      favoriteTracks = favoriteStrings
          .map((item) => Map<String, dynamic>.from(jsonDecode(item)))
          .toList();
    });
  }

  Future<void> playTrack(int index) async {
    final track = favoriteTracks[index];
    try {
      await _audioPlayer.setUrl(track['audioUrl']);
      await _audioPlayer.play();

      setState(() {
        currentIndex = index;
        isPlaying = true;
      });

      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() => isPlaying = false);
        }
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> togglePlayPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    setState(() => isPlaying = _audioPlayer.playing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDE5A0),
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: favoriteTracks.isEmpty
          ? const Center(
              child: Text("No favorite tracks yet",
                  style: TextStyle(color: Colors.white70)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteTracks.length,
              itemBuilder: (context, index) {
                final track = favoriteTracks[index];
                final isCurrent = index == currentIndex;

                return GestureDetector(
                  onTap: () => playTrack(index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: isCurrent ? Colors.white24 : Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          track['imageUrl'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        track['title'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        track['author'],
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Icon(
                        isCurrent && isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
