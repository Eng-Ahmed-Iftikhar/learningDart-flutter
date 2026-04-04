import 'package:sqflite/sqflite.dart';

abstract class DatabaseProvider {
  Database? get getDatabaseOrThrow;

  Future<void> open();
  Future<void> close();
}
