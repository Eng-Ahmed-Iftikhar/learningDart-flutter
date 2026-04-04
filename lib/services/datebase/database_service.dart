import 'package:learningdart/services/datebase/database_contants.dart';
import 'package:learningdart/services/datebase/database_provider.dart';
import 'package:learningdart/services/datebase/database_query.dart';
import 'package:learningdart/services/user/user_exception.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService implements DatabaseProvider {
  Database? _db;

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
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      await db.execute(createUserTable);
      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException catch (_) {
      throw UnableToGetDocumentsDirectory();
    }
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
