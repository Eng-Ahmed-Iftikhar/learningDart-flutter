import 'package:flutter/material.dart';
import 'package:learningdart/services/note/database_note.dart';
import 'package:learningdart/utilties/show_generic_dialog.dart';

typedef DeleteNoteCallback = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final DeleteNoteCallback onDeleteNote;
  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
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
