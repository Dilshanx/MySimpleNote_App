import 'package:flutter/material.dart';
import 'package:projects/screens/view_note_screen.dart';
import 'package:projects/services/database_helper.dart';

import '../model/notes_model.dart';
import 'edit_screen.dart';

// Main screen to display notes
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Database and notes management
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note> _notes = [];

  // Predefined note colors
  final List<Color> _noteColors = [
    Color(0xFFFF6B6B), // Deep Coral Red
    Color(0xFF4ECDC4), // Vibrant Teal
    Color(0xFF45B7D1), // Rich Cerulean Blue
    Color(0xFFF9D56E), // Deep Mustard Yellow
    Color(0xFF665687), // Deep Plum Purple
    Color(0xFFFF8F5E), // Warm Terra Cotta
  ];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // Load notes from database
  Future<void> _loadNotes() async {
    final notes = await _databaseHelper.getNotes();
    print(notes);
    setState(() {
      _notes = notes;
    });
  }

  // Format date for note display
  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(0, '0')}';
    }
    return ' ${dt.day}/${dt.month}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(0, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        title: Text(
          "My Simple Notes Book",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      // Grid view to display notes
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          final color = Color(int.parse(note.color));

          // Tap to view note details
          return GestureDetector(
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewNoteScreen(note: note),
                  ));
              _loadNotes();
            },
            child: Container(
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2)),
                    ]),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      note.content,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Text(_formatDateTime(note.dateTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                )),
          );
        },
      ),
      // Floating button to add new note
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditNoteScreen(),
              ));
          _loadNotes();
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF2E8B57),
        foregroundColor: Colors.white,
      ),
    );
  }
}
