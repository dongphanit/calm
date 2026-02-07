import 'package:calm/firestore_service.dart';
import 'package:calm/screens/calm_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RelaxScreen extends StatefulWidget {
  final Function(String title, String author, String audio, String imageUrl)
      onTrackSelected;

  const RelaxScreen({super.key, required this.onTrackSelected});

  @override
  State<RelaxScreen> createState() => _RelaxScreenState();
}

class _RelaxScreenState extends State<RelaxScreen> {
  List<Map<String, dynamic>> featuredTracks = [];
  List<Map<String, dynamic>> allTracks = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final sleepTracks = await FirestoreService().getRelaxTracks();
    final album = await FirestoreService().getAlbumRelaxTracks();
    setState(() {
      featuredTracks = album.toList(); // 3 bài đầu tiên làm nổi bật
      allTracks = sleepTracks.skip(0).toList(); // các bài còn lại
    });
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
      backgroundColor: Color(0xFFDDE5A0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                'Music',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 38,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              /// Subtitle
              Text(
                'Soothing music to help you relax, focus, and sleep',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 24),

              /// Featured section
              Text(
                'ALBUMS',
                style: TextStyle(
                  color: Colors.white70,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredTracks.length,
                  itemBuilder: (context, index) {
                    final item = featuredTracks[index];
                    return Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: NetworkImage(item['imageUrl']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CalmDetailScreen(
                                        allTracks: item["tracks"],
                                      )),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFDDE5A0).withOpacity(0.5),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title']!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item['author']!,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                ),
              ),

              const SizedBox(height: 24),

              /// All Music
              Text(
                'ALL MUSIC',
                style: TextStyle(
                  color: Colors.white70,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: allTracks.length,
                  itemBuilder: (context, index) {
                    final item = allTracks[index];
                    return GestureDetector(
                        onTap: () {
                          widget.onTrackSelected(
                            item['title']!,
                            item['artist']!,
                            item['audioUrl']!,
                            item['imageUrl']!,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white10,
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
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              item['artist']!,
                              style: TextStyle(color: Colors.white70),
                            ),
                            trailing: Icon(Icons.play_circle_fill,
                                color: Colors.white),
                          ),
                        ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
