import 'package:learningdart/services/datebase/database_contants.dart';
import 'package:learningdart/services/note/note_constants.dart';
import 'package:learningdart/services/user/user_exception.dart';
import 'package:learningdart/services/note/database_note.dart';
import 'package:learningdart/services/datebase/database_service.dart';
import 'package:learningdart/services/user/database_user.dart';
import 'package:learningdart/services/user/user_service.dart';

class NotesService extends DatabaseService {
  final UserService userService;

  NotesService({required this.userService});

  Future<void> deleteNote({required int id}) async {
    await open();
    final db = getDatabaseOrThrow;
    final deletedCount = await db.delete(
      noteTable,
      where: "id = ?",
      whereArgs: [id],
    );
    await close();

    if (deletedCount != 1) {
      throw CouldNotDeleteNote();
    }
  }

  Future<int> deleteAllNote() async {
    await open();

    final db = getDatabaseOrThrow;
    final id = await db.delete(noteTable);
    await close();
    return id;
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    await open();

    final db = getDatabaseOrThrow;
    final dbUser = await userService.getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    final text = "";
    final id = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncWithCloudColumn: 1,
    });
    await close();
    return DatabaseNote(
      id: id,
      text: text,
      userId: dbUser.id,
      isSyncWithCloud: true,
    );
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await open();
    final db = getDatabaseOrThrow;

    final results = await db.query(
      noteTable,
      where: "id = ?",
      limit: 1,
      whereArgs: [id],
    );
    if (results.isEmpty) {
      throw CouldNotFindNote();
    }
    await close();
    return DatabaseNote.fromRow(results.first);
  }

  Future<Iterable<DatabaseNote>> getNotes() async {
    await open();
    final db = getDatabaseOrThrow;
    final results = await db.query(noteTable);
    await close();
    return results.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    await open();
    final db = getDatabaseOrThrow;

    final updateCount = await db.update(
      noteTable,
      {textColumn: text, isSyncWithCloudColumn: 0},
      where: "id = ?",
      whereArgs: [note.id],
    );
    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    }
    final id = await getNote(id: note.id);
    await close();
    return id;
  }
}
