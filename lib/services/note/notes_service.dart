import 'dart:async';

import 'package:learningdart/services/datebase/database_constants.dart';
import 'package:learningdart/services/note/note_constants.dart';
import 'package:learningdart/services/user/user_exception.dart';
import 'package:learningdart/services/note/database_note.dart';
import 'package:learningdart/services/datebase/database_service.dart';
import 'package:learningdart/services/user/database_user.dart';
import 'package:learningdart/services/user/user_service.dart';

class NotesService extends DatabaseService {
  final UserService userService;
  final DatabaseService databaseService;
  List<DatabaseNote> _notes = [];
  final _noteStreamController =
      StreamController<List<DatabaseNote>>.broadcast();

  NotesService(this.databaseService, this.userService);

  factory NotesService.database() =>
      NotesService(DatabaseService(), UserService(DatabaseService()));

  Stream<List<DatabaseNote>> get allNotes => _noteStreamController.stream;

  Future<void> cacheNotes({required Iterable<DatabaseNote> notes}) async {
    _notes = notes.toList();
    _noteStreamController.add(_notes);
  }

  Future<void> deleteNote({required int id}) async {
    await databaseService.ensureDbIsOpen();
    final db = databaseService.getDatabaseOrThrow;
    final deletedCount = await db.delete(
      noteTable,
      where: "id = ?",
      whereArgs: [id],
    );

    if (deletedCount != 1) {
      throw CouldNotDeleteNote();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _noteStreamController.add(_notes);
    }
  }

  Future<int> deleteAllNote() async {
    await databaseService.ensureDbIsOpen();
    final db = databaseService.getDatabaseOrThrow;
    final numberOfDeletions = await db.delete(noteTable);
    _notes = [];
    _noteStreamController.add(_notes);

    return numberOfDeletions;
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    await databaseService.ensureDbIsOpen();
    final db = databaseService.getDatabaseOrThrow;
    final dbUser = await userService.getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    final text = "";
    final id = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });

    final note = DatabaseNote(
      id: id,
      text: text,
      userId: dbUser.id,
      isSyncedWithCloud: true,
    );
    _notes.add(note);
    _noteStreamController.add(_notes);
    return note;
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await databaseService.ensureDbIsOpen();
    final db = databaseService.getDatabaseOrThrow;

    final results = await db.query(
      noteTable,
      where: "id = ?",
      limit: 1,
      whereArgs: [id],
    );
    if (results.isEmpty) {
      throw CouldNotFindNote();
    }

    final note = DatabaseNote.fromRow(results.first);
    _notes.removeWhere((note) => note.id == id);
    _notes.add(note);
    _noteStreamController.add(_notes);
    return note;
  }

  Future<Iterable<DatabaseNote>> getNotes() async {
    final db = databaseService.getDatabaseOrThrow;
    final results = await db.query(noteTable);
    return results.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    await databaseService.ensureDbIsOpen();
    final db = databaseService.getDatabaseOrThrow;

    final updateCount = await db.update(
      noteTable,
      {textColumn: text, isSyncedWithCloudColumn: 0},
      where: "id = ?",
      whereArgs: [note.id],
    );
    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    }
    final updatedNote = await getNote(id: note.id);
    _notes.removeWhere((note) => note.id == updatedNote.id);
    _notes.add(updatedNote);
    _noteStreamController.add(_notes);

    return updatedNote;
  }
}
