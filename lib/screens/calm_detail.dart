import 'package:calm/firestore_service.dart';
import 'package:calm/util.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class CalmDetailScreen extends StatefulWidget {
  List<dynamic> allTracks = [];
  CalmDetailScreen({super.key, required this.allTracks});

  @override
  State<StatefulWidget> createState() {
    return _CalmDetailScreenState();
  }
}

class _CalmDetailScreenState extends State<CalmDetailScreen> {
  

  int? currentIndex = 0; // Index bài đang phát
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();// Sử dụng AudioManager để lấy AudioPlayer
   
    AudioManager.audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        print("Đang playing");
      }

      if (state.processingState == ProcessingState.completed) {
        print("Đã phát xong");
      }

      if (state.processingState == ProcessingState.idle) {
        print("Chưa từng phát hoặc đã được dừng hoàn toàn");
      }
    });
  }

  @override
  void dispose() {
    AudioManager.audioPlayer.dispose(); // Dọn tài nguyên khi rời màn
    super.dispose();
  }

  Future<void> playTrack(int index) async {
    final track = widget.allTracks[index];
    final audioUrl = track['audioUrl'];

    try {
      // check _audioPlayer đã playy chưaa
      if (AudioManager.audioPlayer.playing) {
        await AudioManager.audioPlayer.stop(); // Dừng phát nếu đang phát
      }
      await AudioManager.audioPlayer.setUrl(audioUrl);
      await AudioManager.audioPlayer.play();

      setState(() {
        currentIndex = index;
        isPlaying = true;
      });

      // Theo dõi trạng thái kết thúc
      AudioManager.audioPlayer.playerStateStream.listen((state) {
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
    if (AudioManager.audioPlayer.playing) {
      await AudioManager.audioPlayer.pause();
    } else {
      await AudioManager.audioPlayer.play();
    }
    setState(() {
      isPlaying = AudioManager.audioPlayer.playing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
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
                  Color(0xFFDDE5A0).withOpacity(0.4),
                  Color(0xFFDDE5A0).withOpacity(0.8),
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
                  '',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '',
                  style: TextStyle(
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
                      foregroundColor: Color(0xFFDDE5A0),
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
                    itemCount: widget.allTracks.length,
                    itemBuilder: (context, index) {
                      final item = widget.allTracks[index];
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
                              item['artist']!,
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
