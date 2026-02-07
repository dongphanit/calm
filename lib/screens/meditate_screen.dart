import 'package:calm/firestore_service.dart';
import 'package:calm/screens/calm_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MeditateScreen extends StatefulWidget {
  final Function(String title, String author, String audio, String imageUrl)
      onTrackSelected;

  const MeditateScreen({super.key, required this.onTrackSelected});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RelaxScreenState();
  }
}

class _RelaxScreenState extends State<MeditateScreen> {
  List<Map<String, dynamic>> allTracks = [];
  List<Map<String, dynamic>> featuredTracks = [];
  List<Map<String, dynamic>> albumTracks = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    albumTracks = await FirestoreService().getAlbumMeditationsTracks();
    allTracks = await FirestoreService().getMeditations();

    setState(() {
      allTracks = allTracks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                'Meditate',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 38,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              /// Subtitle
              Text(
                'Guided meditations to help you find calm and focus',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
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
                            item['artist'] ?? "",
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
                              item['artist'] ?? "",
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
