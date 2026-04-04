import 'package:learningdart/services/datebase/database_contants.dart';
import 'package:learningdart/services/datebase/database_service.dart';
import 'package:learningdart/services/user/database_user.dart';
import 'package:learningdart/services/user/user_constants.dart';
import 'package:learningdart/services/user/user_exception.dart';

class UserService extends DatabaseService {
  Future<void> deleteUser({required String email}) async {
    final db = getDatabaseOrThrow;
    final deletedCount = await db.delete(
      userTable,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = getDatabaseOrThrow;
    final results = await db.query(
      userTable,
      where: "email = ?",
      limit: 1,
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final id = await db.insert(userTable, {emailColumn: email.toLowerCase()});
    return DatabaseUser(id: id, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = getDatabaseOrThrow;
    final results = await db.query(
      userTable,
      where: "email = ?",
      limit: 1,
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotFindUser();
    }
    return DatabaseUser.fromRow(results.first);
  }
}
