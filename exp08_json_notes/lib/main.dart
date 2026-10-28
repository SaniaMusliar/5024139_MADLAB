
import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Notes',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<Map<String, dynamic>> notes = [
    {'title': 'Flutter', 'text': 'Learn widgets and layouts'},
    {'title': 'DSA', 'text': 'Practice arrays and strings'},
    {'title': 'Database', 'text': 'Revise SQL queries'},
  ];

  void addNote() {
    setState(() {
      notes.add({
        'title': 'New Note',
        'text': 'Sample note added',
      });
    });
  }

  void deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  String convertToJson() {
    return jsonEncode(notes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(convertToJson()),
                  duration: const Duration(seconds: 5),
                ),
              );
            },
            icon: const Icon(Icons.data_object),
          ),
        ],
      ),
      body: notes.isEmpty
          ? const Center(child: Text('No notes available'))
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.note),
                    ),
                    title: Text(
                      notes[index]['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(notes[index]['text']),
                    trailing: IconButton(
                      onPressed: () => deleteNote(index),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addNote,
        icon: const Icon(Icons.add),
        label: const Text('Add Note'),
      ),
    );
  }
}
