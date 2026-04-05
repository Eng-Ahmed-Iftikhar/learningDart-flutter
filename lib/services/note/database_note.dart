import 'package:learningdart/services/datebase/database_constants.dart';
import 'package:learningdart/services/note/note_constants.dart';

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncWithCloud;
  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncWithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
    : id = map[idColumn] as int,
      userId = map[userIdColumn] as int,
      text = map[textColumn] as String,
      isSyncWithCloud = (map[isSyncWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Person, ID = $id, userif = $userId, isSyncWithCloud= $isSyncWithCloud,text= $text';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
