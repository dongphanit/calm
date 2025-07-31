import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String title;
  final String author;
  final String imageUrl;

  const MusicPlayerScreen({
    super.key,
    required this.title,
    required this.author,
    required this.imageUrl,
  });

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool isPlaying = false;
  double progress = 0.3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// Background image
          Positioned.fill(
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          /// Overlay content
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
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.author,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  /// Spacer
                  const SizedBox(height: 40),

                  /// Progress bar
                  Column(
                    children: [
                      Slider(
                        value: progress,
                        onChanged: (value) {
                          setState(() => progress = value);
                        },
                        activeColor: Colors.white,
                        inactiveColor: Colors.white24,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("0:45",
                                style: TextStyle(color: Colors.white70)),
                            Text("3:15",
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  /// Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.fast_rewind,
                            color: Colors.white, size: 36),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: () {
                          setState(() => isPlaying = !isPlaying);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 36,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        icon: const Icon(Icons.fast_forward,
                            color: Colors.white, size: 36),
                        onPressed: () {
                          
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
