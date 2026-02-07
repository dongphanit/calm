import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Simple Admin Dashboard to manage Firebase data
class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final List<_AdminCollection> collections = const [
    _AdminCollection('Daily Calm', 'daily_calm'),
    _AdminCollection('Yoga Tracks', 'yoga_tracks'),
    _AdminCollection('Relax Tracks', 'relax_tracks'),
    _AdminCollection('Meditations', 'meditations'),
    _AdminCollection('Albums', 'albums'),
  ];

  String selectedCollection = 'daily_calm';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔥 Firebase Admin Dashboard'),
      ),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(child: _buildCollectionView()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 220,
      color: Colors.grey.shade100,
      child: ListView(
        children: collections.map((c) {
          final selected = c.key == selectedCollection;
          return ListTile(
            selected: selected,
            title: Text(c.label),
            onTap: () => setState(() => selectedCollection = c.key),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCollectionView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection(selectedCollection).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text('No data'));
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;

            return Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                title: Text(data['title'] ?? 'No title'),
                subtitle: Text(doc.id),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showAddDialog(docId: doc.id,
    oldData: data,),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteDoc(doc.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _deleteDoc(String id) async {
    await _db.collection(selectedCollection).doc(id).delete();
  }

  void _showAddDialog({String? docId, Map<String, dynamic>? oldData}) {
  final titleCtrl = TextEditingController(text: oldData?['title']);
  final artistCtrl = TextEditingController(text: oldData?['artist']);
  final durationCtrl =
      TextEditingController(text: oldData?['duration']?.toString());

  final imageUrl = TextEditingController(text: oldData?['imageUrl']);
  final audioUrl = TextEditingController(text: oldData?['audioUrl']);

  

  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(docId == null ? 'Add Track' : 'Edit Track'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: artistCtrl,
                decoration: const InputDecoration(labelText: 'Artist'),
              ),
              TextField(
                controller: durationCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Duration (min)'),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: imageUrl,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'image Url'),
              ),
                TextField(
                controller: audioUrl,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'audio Url'),
              ),

            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () async {
              String imageUrl = oldData?['imageUrl'] ?? '';
              String audioUrl = oldData?['audioUrl'] ?? '';

              final data = {
                'title': titleCtrl.text,
                'artist': artistCtrl.text,
                'duration': int.tryParse(durationCtrl.text) ?? 0,
                'imageUrl': imageUrl,
                'audioUrl': audioUrl,
                'updatedAt': FieldValue.serverTimestamp(),
              };

              final col = _db.collection(selectedCollection);

              if (docId == null) {
                await col.add({
                  ...data,
                  'createdAt': FieldValue.serverTimestamp(),
                });
              } else {
                await col.doc(docId).update(data);
              }

              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}

  void _showEditDialog(String id, Map<String, dynamic> data) {
    final titleController = TextEditingController(text: data['title']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit item'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        actions: [
          TextButton(onPressed: Navigator.of(context).pop, child: const Text('Cancel')),
          ElevatedButton(
            child: const Text('Update'),
            onPressed: () async {
              await _db.collection(selectedCollection).doc(id).update({
                'title': titleController.text,
              });
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}

class _AdminCollection {
  final String label;
  final String key;

  const _AdminCollection(this.label, this.key);
}
