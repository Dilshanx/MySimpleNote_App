import 'package:flutter/material.dart';
import 'package:projects/services/database_helper.dart';

import '../model/notes_model.dart';
import 'edit_screen.dart';

// Screen to view individual note details
class ViewNoteScreen extends StatelessWidget {
  // Note to be displayed
  final Note note;

  ViewNoteScreen({required this.note});

  // Database helper for note operations
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Format date for display
  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return '${dt.day}/${dt.month}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse(note.color)),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        // Edit and delete actions
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditNoteScreen(
                      note: note,
                    ),
                  ));
            },
            icon: Icon(Icons.edit, color: Colors.white),
          ),
          IconButton(
              onPressed: () => _showDeleteDialog(context),
              icon: Icon(Icons.delete, color: Colors.white)),
          SizedBox(width: 8)
        ],
      ),
      body: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Note title and timestamp
        Padding(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              Row(children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  _formatDateTime(note.dateTime),
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ])
            ],
          ),
        ),
        // Note content
        Expanded(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, 32, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Text(
                note.content,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.8),
                  height: 1.6,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        )
      ])),
    );
  }

  // Show delete confirmation dialog
  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirm = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                "Delete Note",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.grey[900],
                  letterSpacing: 0.5,
                ),
              ),
              content: Text(
                "Are you sure you want to delete this note?",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.blueGrey[600],
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color: Colors.red[700],
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      letterSpacing: 0.3,
                    ),
                  ),
                )
              ],
            ));

    // Perform deletion if confirmed
    if (confirm == true) {
      await _databaseHelper.deleteNote(note.id!);
      Navigator.pop(context);
    }
  }
}
