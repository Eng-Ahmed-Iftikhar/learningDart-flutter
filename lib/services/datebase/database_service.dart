import 'package:learningdart/services/datebase/database_constants.dart';
import 'package:learningdart/services/datebase/database_provider.dart';
import 'package:learningdart/services/datebase/database_query.dart';
import 'package:learningdart/services/note/database_note.dart';
import 'package:learningdart/services/note/notes_service.dart';
import 'package:learningdart/services/user/user_exception.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService implements DatabaseProvider {
  Database? _db;
  static final DatabaseService _shared = DatabaseService._sharedInstance();
  DatabaseService._sharedInstance();
  factory DatabaseService() => _shared;

  @override
  Database get getDatabaseOrThrow {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  @override
  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getDatabasesPath();

      final dbPath = join(docsPath, dbName);

      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);
      await db.execute(createNoteTable);
      final notes = await db.query(noteTable);

      await NotesService.database().cacheNotes(
        notes: notes.map((noteRow) => DatabaseNote.fromRow(noteRow)),
      );
    } on MissingPlatformDirectoryException catch (e) {
      print(e);
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {}
  }

  @override
  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }
}
