import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class DatabaseHelper {
  static const _databaseName = 'user_database.db';
  static const _databaseVersion = 1;
  static const table = 'users';

  static const columnId = 'id';
  static const columnEmail = 'email';
  static const columnPassword = 'password';
  static const columnUsername = 'username';
  static const columnIsLoggedIn = 'isLoggedIn'; // New column to track login status

  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  // Open the database and create the table if it doesn't exist
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database with the new 'isLoggedIn' column
  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    return await openDatabase(
      join(path, _databaseName),
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnEmail TEXT NOT NULL,
            $columnPassword TEXT NOT NULL,
            $columnUsername TEXT NOT NULL,
            $columnIsLoggedIn INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  // Insert a new user
  Future<int> insertUser(Map<String, dynamic> user) async {
    final Database db = await database;
    return await db.insert(table, user);
  }

  // Get a user by email
  Future<Map<String, dynamic>?> getUser(String email) async {
    final Database db = await database;
    final result = await db.query(
      table,
      where: '$columnEmail = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Get the login status of a user
  Future<bool> isUserLoggedIn() async {
  final Database db = await database;
  final result = await db.query(
    table,
    where: '$columnIsLoggedIn = 1',  // Перевірка, чи користувач залогінений
  );
  return result.isNotEmpty;
}

  // Set the login status of a user
  Future<void> setUserLoggedIn(String email, bool isLoggedIn) async {
    final Database db = await database;
    await db.update(
      table,
      {columnIsLoggedIn: isLoggedIn ? 1 : 0},
      where: '$columnEmail = ?',
      whereArgs: [email],
    );
  }

  // Delete a user by id
  Future<int> deleteUser(int id) async {
    final Database db = await database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
