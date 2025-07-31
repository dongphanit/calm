import 'package:calm/firestore_service.dart';
import 'package:calm/screens/calm_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MeditateScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MusicPlayerScreenState();
  }
  
}


class _MusicPlayerScreenState extends State<MeditateScreen> {
 
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
   allTracks= await  FirestoreService().getMeditations();

    setState(() {
      allTracks = allTracks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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

              /// Grid of categories
              Expanded(
                child: GridView.builder(
                  itemCount: allTracks.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (context, index) {
                    final item = allTracks[index];
                    return GestureDetector(
                      onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CalmDetailScreen(
                                        allTracks: item["tracks"],
                                      )),
                            );
                      },
                      child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            item['imageUrl']!,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            bottom: 12,
                            right: 12,
                            child: Text(
                              item['title']!,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    );
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
