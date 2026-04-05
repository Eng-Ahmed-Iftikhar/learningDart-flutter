import 'package:flutter/material.dart';
import 'package:learningdart/services/note/database_note.dart';
import 'package:learningdart/utilties/show_generic_dialog.dart';

typedef NoteCallback = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTapNote;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTapNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Card(
          elevation: 1, // shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: Colors.grey.shade200), // border
          ),
          child: ListTile(
            onTap: () {
              onTapNote(note);
            },
            title: Text(
              note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final shouldDelete = await showGenericDialog(
                  context: context,
                  title: "Delete note",
                  content: "You really want to delete this note?",
                  optionsBuilder: () => {"Cancel": false, "Delete": true},
                );
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
