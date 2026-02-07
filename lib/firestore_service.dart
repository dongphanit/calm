import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Daily Calm tracks collection
  Future<List<Map<String, dynamic>>> getDailyTracks() async {
    final snapshot = await _db.collection('daily_calm').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Get all yoga tracks
  Future<List<Map<String, dynamic>>> getYogaTracks() async {
    final snapshot = await _db.collection('yoga_tracks').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Get all meditation sessions
  Future<List<Map<String, dynamic>>> getMeditations() async {
    final snapshot = await _db.collection('meditations').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Get all relax tracks
  Future<List<Map<String, dynamic>>> getRelaxTracks() async {
    final snapshot = await _db.collection('relax_tracks').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getAlbumRelaxTracks() async {
    final snapshot = await _db.collection('albums').get();
    // lọc album có type là relax
    final relaxAlbums =
        snapshot.docs.where((doc) => doc.data()['type'] == 'relax');
    return relaxAlbums.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getAlbumYogaTracks() async {
    final snapshot = await _db.collection('albums').get();
    // lọc album có type là relax
    final relaxAlbums =
        snapshot.docs.where((doc) => doc.data()['type'] == 'yoga');
    return relaxAlbums.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getAlbumMeditationsTracks() async {
    final snapshot = await _db.collection('albums').get();
    // lọc album có type là relax
    final relaxAlbums =
        snapshot.docs.where((doc) => doc.data()['type'] == 'meditation');
    return relaxAlbums.map((doc) => doc.data()).toList();
  }

  // lll
  /// Seed dummy data for multiple relax albums

  Future<void> seedMultipleRelaxAlbums() async {
    final List<Map<String, dynamic>> albums = [
      {
        "title": "Nature Relax",
        "description": "Instrumental relax inspired by nature.",
        "imageUrl": "https://i.imgur.com/XRrZfAl.jpg",
        "author": "Calm App",
        "type": "relax",
        "tracks": [
          {
            "title": "Mountain Air",
            "artist": "NatureTone",
            "imageUrl": "https://i.imgur.com/XRrZfAl.jpg",
            "duration": 12,
            "audioUrl":
                "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/02%20Yogay%20Twilight%20-%20Guided%20Meditati.mp3"
          },
          {
            "title": "Forest Piano",
            "artist": "Green Keys",
            "imageUrl": "https://i.imgur.com/0rVeh4b.jpg",
            "duration": 18,
            "audioUrl":
                "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/03%20Forest%20Piano.mp3"
          },
          {
            "title": "River Flow",
            "artist": "Soft River",
            "imageUrl": "https://i.imgur.com/LK2ZpOZ.jpg",
            "duration": 10,
            "audioUrl":
                "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/04%20River%20Flow.mp3"
          }
        ]
      },
      {
        "title": "Calm Vibes",
        "description": "Relaxing ambient relax for yoga and study.",
        "imageUrl": "https://i.imgur.com/vZ3Fz9p.jpg",
        "author": "Calm App",
        "type": "relax",
        "tracks": [
          {
            "title": "Evening Breeze",
            "artist": "Dreamer",
            "imageUrl": "https://i.imgur.com/4ZQZQ3a.jpg",
            "duration": 14,
            "audioUrl":
                "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/05%20Evening%20Breeze.mp3"
          },
          {
            "title": "Night Forest",
            "artist": "Silent Trees",
            "imageUrl": "https://i.imgur.com/Z34jQ3a.jpg",
            "duration": 20,
            "audioUrl":
                "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/06%20Night%20Forest.mp3"
          },
          {
            "title": "Gentle Lake",
            "artist": "WaterTouch",
            "imageUrl": "https://i.imgur.com/GZ3lZaa.jpg",
            "duration": 16,
            "audioUrl":
                "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/07%20Gentle%20Lake.mp3"
          }
        ]
      },
      {
        "title": "Deep Yoga Sounds",
        "description": "Soothing sounds for deep yoga.",
        "imageUrl": "https://i.imgur.com/hgU3yNJ.jpg",
        "author": "Calm App",
        "type": "relax",
        "tracks": [
          {
            "title": "Ocean Waves",
            "artist": "Blue Horizon",
            "imageUrl": "https://i.imgur.com/7CkY6B9.jpg",
            "duration": 22,
            "audioUrl":
                "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/08%20Ocean%20Waves.mp3"
          },
          {
            "title": "Rain Drops",
            "artist": "Rainy Day",
            "imageUrl": "https://i.imgur.com/uB3ZQ2e.jpg",
            "duration": 19,
            "audioUrl":
                "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/09%20Rain%20Drops.mp3"
          },
          {
            "title": "Windy Hills",
            "artist": "Calm Wind",
            "imageUrl": "https://i.imgur.com/XH3zYAf.jpg",
            "duration": 17,
            "audioUrl":
                "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/10%20Windy%20Hills.mp3"
          }
        ]
      },
    ];

    for (int i = 0; i < albums.length; i++) {
      final albumId = 'album_relax_$i';
      await _db.collection('albums').doc(albumId).set(albums[i]);
    }

    print('✅ Seeded ${albums.length} relax albums!');
  }

  /// Seed dummy data Daily Tracks
  Future<void> seedDailyCalmTracks() async {
    final List<Map<String, dynamic>> dailyTracks = [
      {
        "title": "Morning Calm",
        "author": "Clara Moon",
        "imageUrl": "https://i.imgur.com/hgU3yNJ.jpg",
        "duration": 10,
        "audioUrl":
            "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/02%20Yogay%20Twilight%20-%20Guided%20Meditati.mp3",
      },
      {
        "title": "Evening Relaxation",
        "author": "Leo Sound",
        "imageUrl": "https://i.imgur.com/qnN4jPM.jpg",
        "duration": 12,
        "audioUrl":
            "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/02%20Yogay%20Twilight%20-%20Guided%20Meditati.mp3",
      },
    ];

    for (int i = 0; i < dailyTracks.length; i++) {
      await _db.collection('daily_calm').doc('daily_00$i').set(dailyTracks[i]);
    }
  }

  /// Seed dummy data
  Future<void> seedDummyData() async {
    await _seedYogaTracks();
    await _seedMeditations();
    await _seedRelaxTracks();
    print('✅ Dummy data seeded successfully!');
  }

  Future<void> _seedYogaTracks() async {
    final List<Map<String, dynamic>> yogaTracks = [
      {
        "title": "Ocean Yoga",
        "author": "Clara Moon",
        "imageUrl": "https://i.imgur.com/8Km9tLL.jpg",
        "duration": 15,
        "audioUrl":
            "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/02%20Yogay%20Twilight%20-%20Guided%20Meditati.mp3",
        "tags": ["ocean", "night"],
      },
      {
        "title": "Rainy Night",
        "author": "Leo Sound",
        "imageUrl": "https://i.imgur.com/vZ3Fz9p.jpg",
        "duration": 20,
        "audioUrl":
            "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/02%20Yogay%20Twilight%20-%20Guided%20Meditati.mp3",
        "tags": ["rain", "calm"],
      },
    ];

    for (int i = 0; i < yogaTracks.length; i++) {
      await _db
          .collection('yoga_tracks')
          .doc('yoga_00$i')
          .set(yogaTracks[i]);
    }
  }

  Future<void> _seedMeditations() async {
    final List<Map<String, dynamic>> meditations = [
      {
        "title": "Daily Calm",
        "category": "Focus",
        "imageUrl": "https://i.imgur.com/hgU3yNJ.jpg",
        "duration": 10,
        "audioUrl":
            "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/02%20Yogay%20Twilight%20-%20Guided%20Meditati.mp3",
      },
      {
        "title": "Mindful Morning",
        "category": "Energy",
        "imageUrl": "https://i.imgur.com/qnN4jPM.jpg",
        "duration": 12,
        "audioUrl":
            "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/02%20Yogay%20Twilight%20-%20Guided%20Meditati.mp3",
      },
    ];

    for (int i = 0; i < meditations.length; i++) {
      await _db
          .collection('meditations')
          .doc('meditation_00$i')
          .set(meditations[i]);
    }
  }

  Future<void> _seedRelaxTracks() async {
    final List<Map<String, dynamic>> relaxTracks = [
      {
        "title": "Mountain Air",
        "artist": "NatureTone",
        "imageUrl": "https://i.imgur.com/XRrZfAl.jpg",
        "duration": 12,
        "audioUrl":
            "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/02%20Yogay%20Twilight%20-%20Guided%20Meditati.mp3",
      },
      {
        "title": "Forest Piano",
        "artist": "Green Keys",
        "imageUrl": "https://i.imgur.com/0rVeh4bl.jpg",
        "duration": 18,
        "audioUrl":
            "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/02%20Yogay%20Twilight%20-%20Guided%20Meditati.mp3",
      },
    ];

    for (int i = 0; i < relaxTracks.length; i++) {
      await _db
          .collection('relax_tracks')
          .doc('relax_00$i')
          .set(relaxTracks[i]);
    }
  }

  Future<void> _seedBreathingTracks() async {
    final List<Map<String, dynamic>> breathings = [
      {
        "title": "breathings Air",
        "artist": "breathings",
        "imageUrl": "https://i.imgur.com/XRrZfAl.jpg",
        "duration": 12,
        "audioUrl":
            "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/02%20Yogay%20Twilight%20-%20Guided%20Meditati.mp3",
      },
      {
        "title": "breathings Piano",
        "artist": "breathings Keys",
        "imageUrl": "https://i.imgur.com/0rVeh4bl.jpg",
        "duration": 18,
        "audioUrl":
            "https://ia601902.us.archive.org/3/items/GentlyFallAyoga/02%20Yogay%20Twilight%20-%20Guided%20Meditati.mp3",
      },
    ];

    for (int i = 0; i < breathings.length; i++) {
      await _db
          .collection('breathing_tracks')
          .doc('breathing_00$i')
          .set(breathings[i]);
    }
  }
}

