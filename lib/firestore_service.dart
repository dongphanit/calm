import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  /// Daily Calm tracks collection
   Future<List<Map<String, dynamic>>> getDailyTracks() async {
    final snapshot = await _db.collection('daily_calm').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Get all sleep tracks
  Future<List<Map<String, dynamic>>> getSleepTracks() async {
    final snapshot = await _db.collection('sleep_tracks').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Get all meditation sessions
  Future<List<Map<String, dynamic>>> getMeditations() async {
    final snapshot = await _db.collection('meditations').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Get all music tracks
  Future<List<Map<String, dynamic>>> getMusicTracks() async {
    final snapshot = await _db.collection('music_tracks').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getAlbumMusicTracks() async {
    final snapshot = await _db.collection('albums').get();
    // lọc album có type là music
    final musicAlbums = snapshot.docs.where((doc) => doc.data()['type'] == 'music');
    return musicAlbums.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getAlbumSleepTracks() async {
    final snapshot = await _db.collection('albums').get();
    // lọc album có type là music
    final musicAlbums = snapshot.docs.where((doc) => doc.data()['type'] == 'sleep');
    return musicAlbums.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getAlbumMeditationsTracks() async {
    final snapshot = await _db.collection('albums').get();
    // lọc album có type là music
    final musicAlbums = snapshot.docs.where((doc) => doc.data()['type'] == 'meditation');
    return musicAlbums.map((doc) => doc.data()).toList();
  }

  
  // lll
  /// Seed dummy data for multiple music albums




  
Future<void> seedMultipleMusicAlbums() async {
  final List<Map<String, dynamic>> albums = [
    {
      "title": "Nature Music",
      "description": "Instrumental music inspired by nature.",
      "imageUrl": "https://i.imgur.com/XRrZfAl.jpg",
      "author": "Calm App",
      "type": "music",
      "tracks": [
        {
          "title": "Mountain Air",
          "artist": "NatureTone",
          "imageUrl": "https://i.imgur.com/XRrZfAl.jpg",
          "duration": 12,
          "audioUrl": "https://ia601902.us.archive.org/3/items/GentlyFallAsleep/02%20Sleepy%20Twilight%20-%20Guided%20Meditati.mp3"
        },
        {
          "title": "Forest Piano",
          "artist": "Green Keys",
          "imageUrl": "https://i.imgur.com/0rVeh4b.jpg",
          "duration": 18,
          "audioUrl": "https://ia601902.us.archive.org/3/items/GentlyFallAsleep/03%20Forest%20Piano.mp3"
        },
        {
          "title": "River Flow",
          "artist": "Soft River",
          "imageUrl": "https://i.imgur.com/LK2ZpOZ.jpg",
          "duration": 10,
          "audioUrl": "https://ia601902.us.archive.org/3/items/GentlyFallAsleep/04%20River%20Flow.mp3"
        }
      ]
    },
    {
      "title": "Calm Vibes",
      "description": "Relaxing ambient music for sleep and study.",
      "imageUrl": "https://i.imgur.com/vZ3Fz9p.jpg",
      "author": "Calm App",
      "type": "music",
      "tracks": [
        {
          "title": "Evening Breeze",
          "artist": "Dreamer",
          "imageUrl": "https://i.imgur.com/4ZQZQ3a.jpg",
          "duration": 14,
          "audioUrl": "https://ia601902.us.archive.org/3/items/GentlyFallAsleep/05%20Evening%20Breeze.mp3"
        },
        {
          "title": "Night Forest",
          "artist": "Silent Trees",
          "imageUrl": "https://i.imgur.com/Z34jQ3a.jpg",
          "duration": 20,
          "audioUrl": "https://ia601902.us.archive.org/3/items/GentlyFallAsleep/06%20Night%20Forest.mp3"
        },
        {
          "title": "Gentle Lake",
          "artist": "WaterTouch",
          "imageUrl": "https://i.imgur.com/GZ3lZaa.jpg",
          "duration": 16,
          "audioUrl": "https://ia601902.us.archive.org/3/items/GentlyFallAsleep/07%20Gentle%20Lake.mp3"
        }
      ]
    },
    {
      "title": "Deep Sleep Sounds",
      "description": "Soothing sounds for deep sleep.",
      "imageUrl": "https://i.imgur.com/hgU3yNJ.jpg",
      "author": "Calm App",
      "type": "music",
      "tracks": [
        {
          "title": "Ocean Waves",
          "artist": "Blue Horizon",
          "imageUrl": "https://i.imgur.com/7CkY6B9.jpg",
          "duration": 22,
          "audioUrl": "https://ia601902.us.archive.org/3/items/GentlyFallAsleep/08%20Ocean%20Waves.mp3"
        },
        {
          "title": "Rain Drops",
          "artist": "Rainy Day",
          "imageUrl": "https://i.imgur.com/uB3ZQ2e.jpg",
          "duration": 19,
          "audioUrl": "https://ia601902.us.archive.org/3/items/GentlyFallAsleep/09%20Rain%20Drops.mp3"
        },
        {
          "title": "Windy Hills",
          "artist": "Calm Wind",
          "imageUrl": "https://i.imgur.com/XH3zYAf.jpg",
          "duration": 17,
          "audioUrl": "https://ia601902.us.archive.org/3/items/GentlyFallAsleep/10%20Windy%20Hills.mp3"
        }
      ]
    },
  ];

  for (int i = 0; i < albums.length; i++) {
    final albumId = 'album_music_$i';
    await _db.collection('albums').doc(albumId).set(albums[i]);
  }

  print('✅ Seeded ${albums.length} music albums!');
}

  /// Seed dummy data Daily Tracks
  Future<void> seedDailyCalmTracks() async {
    final List<Map<String, dynamic>> dailyTracks = [
      {
        "title": "Morning Calm",
        "author": "Clara Moon",
        "imageUrl": "https://i.imgur.com/hgU3yNJ.jpg",
        "duration": 10,
        "audioUrl": "https://ia601902.us.archive.org/3/items/GentlyFallAsleep/02%20Sleepy%20Twilight%20-%20Guided%20Meditati.mp3",
      },
      {
        "title": "Evening Relaxation",
        "author": "Leo Sound",
        "imageUrl": "https://i.imgur.com/qnN4jPM.jpg",
        "duration": 12,
        "audioUrl": "https://ia601902.us.archive.org/3/items/GentlyFallAsleep/02%20Sleepy%20Twilight%20-%20Guided%20Meditati.mp3",
      },
    ];

    for (int i = 0; i < dailyTracks.length; i++) {
      await _db.collection('daily_calm').doc('daily_00$i').set(dailyTracks[i]);
    }
  }
  
   /// Seed dummy data
  Future<void> seedDummyData() async {
    await _seedSleepTracks();
    await _seedMeditations();
    await _seedMusicTracks();
    print('✅ Dummy data seeded successfully!');
  }

  Future<void> _seedSleepTracks() async {
    final List<Map<String, dynamic>> sleepTracks = [
      {
        "title": "Ocean Sleep",
        "author": "Clara Moon",
        "imageUrl": "https://i.imgur.com/8Km9tLL.jpg",
        "duration": 15,
        "audioUrl": "https://ia601902.us.archive.org/3/items/GentlyFallAsleep/02%20Sleepy%20Twilight%20-%20Guided%20Meditati.mp3",
        "tags": ["ocean", "night"],
      },
      {
        "title": "Rainy Night",
        "author": "Leo Sound",
        "imageUrl": "https://i.imgur.com/vZ3Fz9p.jpg",
        "duration": 20,
        "audioUrl": "https://ia601902.us.archive.org/3/items/GentlyFallAsleep/02%20Sleepy%20Twilight%20-%20Guided%20Meditati.mp3",
        "tags": ["rain", "calm"],
      },
    ];

    for (int i = 0; i < sleepTracks.length; i++) {
      await _db.collection('sleep_tracks').doc('sleep_00$i').set(sleepTracks[i]);
    }
  }

  Future<void> _seedMeditations() async {
    final List<Map<String, dynamic>> meditations = [
      {
        "title": "Daily Calm",
        "category": "Focus",
        "imageUrl": "https://i.imgur.com/hgU3yNJ.jpg",
        "duration": 10,
        "audioUrl": "https://ia601902.us.archive.org/3/items/GentlyFallAsleep/02%20Sleepy%20Twilight%20-%20Guided%20Meditati.mp3",
      },
      {
        "title": "Mindful Morning",
        "category": "Energy",
        "imageUrl": "https://i.imgur.com/qnN4jPM.jpg",
        "duration": 12,
        "audioUrl": "https://ia601902.us.archive.org/3/items/GentlyFallAsleep/02%20Sleepy%20Twilight%20-%20Guided%20Meditati.mp3",
      },
    ];

    for (int i = 0; i < meditations.length; i++) {
      await _db.collection('meditations').doc('meditation_00$i').set(meditations[i]);
    }
  }

  Future<void> _seedMusicTracks() async {
    final List<Map<String, dynamic>> musicTracks = [
      {
        "title": "Mountain Air",
        "artist": "NatureTone",
        "imageUrl": "https://i.imgur.com/XRrZfAl.jpg",
        "duration": 12,
        "audioUrl": "https://ia601902.us.archive.org/3/items/GentlyFallAsleep/02%20Sleepy%20Twilight%20-%20Guided%20Meditati.mp3",
      },
      {
        "title": "Forest Piano",
        "artist": "Green Keys",
        "imageUrl": "https://i.imgur.com/0rVeh4bl.jpg",
        "duration": 18,
        "audioUrl": "https://ia601902.us.archive.org/3/items/GentlyFallAsleep/02%20Sleepy%20Twilight%20-%20Guided%20Meditati.mp3",
      },
    ];

    for (int i = 0; i < musicTracks.length; i++) {
      await _db.collection('music_tracks').doc('music_00$i').set(musicTracks[i]);
    }
  }
}
