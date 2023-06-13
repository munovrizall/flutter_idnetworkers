import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper/database/note_database.dart';
import 'package:note_keeper/pages/add_edit_note_page.dart';
import '../model/note.dart';

class NoteDetailPage extends StatefulWidget {
  final int id;

  const NoteDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      // color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    DateFormat.yMMMd().format(note.createdTime),
                    // style: const TextStyle(color: Colors.white38),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    note.description,
                    style: const TextStyle(
                      // color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
              ));
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });

    note = await NoteDatabase.instance.getNoteById(widget.id);

    setState(() {
      isLoading = false;
    });
  }

  Widget editButton() =>
      IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () async {
            final route = MaterialPageRoute(
                builder: (context) => AddEditNotePage(note: note,
                ));
            await Navigator.push(context, route);
            refreshNotes();
          });

  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          if (isLoading) return;
          await NoteDatabase.instance.deleteNoteById(note.id!);
          Navigator.pop(context);
        },
      );
}
