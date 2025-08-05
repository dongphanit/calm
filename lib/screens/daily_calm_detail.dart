import 'package:calm/firestore_service.dart';
import 'package:calm/util.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:intl/intl.dart';
class DailyCalmDetailScreen extends StatefulWidget {
  const DailyCalmDetailScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DailyCalmDetailScreenState();
  }
}

class _DailyCalmDetailScreenState extends State<DailyCalmDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Map<String, dynamic>> allTracks = [];

  int? currentIndex = 0; // Index bài đang phát
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    AudioManager.audioPlayer.stop(); // Dừng phát nếu đang phát trước đó
    loadData();
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dọn tài nguyên khi rời màn
    super.dispose();
  }

  Future<void> loadData() async {
    final tracks = await FirestoreService().getDailyTracks();
    setState(() {
      allTracks = tracks;
    });
  }

  Future<void> playTrack(int index) async {
    setState(() {
            isPlaying = false;
          });
    final track = allTracks[index];
    final audioUrl = track['audioUrl'];

    try {
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();

      setState(() {
        currentIndex = index;
        isPlaying = true;
      });

      // Theo dõi trạng thái kết thúc
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            isPlaying = false;
          });
        }
      });
    } catch (e) {
      print("Lỗi phát audio: $e");
    }
  }

  Future<void> togglePlayPause() async {
   
    setState(() {
      isPlaying = !isPlaying; // Cập nhật trạng thái khi tạm dừng
    });
     if (_audioPlayer.playing) {
      await _audioPlayer.pause();
      
    } else {
      await _audioPlayer.play();
    
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Quay về màn hình trước
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1518837695005-2083093ee35b'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Calm',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                // Trong Widget:
                Text(
                  '${DateFormat('MMMM d').format(DateTime.now())} • The Present Moment',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentIndex != null) {
                        togglePlayPause();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Enjoy today’s guided session to help you be present and mindful. Take a few minutes to relax and reset your mind.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: allTracks.length,
                    itemBuilder: (context, index) {
                      final item = allTracks[index];
                      final isCurrent = index == currentIndex;

                      return GestureDetector(
                        onTap: () {
                          playTrack(index);
                        },
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
                                item['imageUrl']!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              item['title']!,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              item['author']!,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: Icon(
                              isCurrent && isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_fill,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
