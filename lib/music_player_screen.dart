import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class RelaxScreen extends StatefulWidget {
  @override
  _RelaxScreenState createState() => _RelaxScreenState();
}

class _RelaxScreenState extends State<RelaxScreen> {
  final AudioPlayer _player = AudioPlayer();

  final String trackUrl =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
  final String trackTitle = 'The Present Moment';
  final String trackArtist = 'Calm Voice';
  final String trackImage =
      'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _player.setUrl(trackUrl);
  }

  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
        _player.positionStream,
        _player.durationStream,
        (position, duration) => DurationState(
          position: position,
          total: duration ?? Duration.zero,
        ),
      );

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(trackTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(trackImage),
            ),
            const SizedBox(height: 32),
            Text(
              trackTitle,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            Text(
              trackArtist,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 32),
            StreamBuilder<DurationState>(
              stream: _durationStateStream,
              builder: (context, snapshot) {
                final durationState = snapshot.data;
                final position = durationState?.position ?? Duration.zero;
                final total = durationState?.total ?? Duration.zero;
                return Column(
                  children: [
                    Slider(
                      min: 0.0,
                      max: total.inMilliseconds.toDouble(),
                      value: position.inMilliseconds
                          .clamp(0, total.inMilliseconds)
                          .toDouble(),
                      onChanged: (value) {
                        _player.seek(Duration(milliseconds: value.toInt()));
                      },
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(position),
                            style: TextStyle(color: Colors.white70)),
                        Text(_formatDuration(total),
                            style: TextStyle(color: Colors.white70)),
                      ],
                    )
                  ],
                );
              },
              
            ),
            const SizedBox(height: 24),
            StreamBuilder<bool>(
              stream: _player.playingStream,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data ?? false;
                return IconButton(
                  iconSize: 64,
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      _player.pause();
                    } else {
                      _player.play();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}

class DurationState {
  final Duration position;
  final Duration total;

  DurationState({required this.position, required this.total});
}
