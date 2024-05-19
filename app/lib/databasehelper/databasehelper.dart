import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  late Database _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<void> initializeDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'example_database.db');
    _database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> updateFirstName(String newName) async {
    await _database.rawUpdate(
      'UPDATE your_table SET first_name = ?',
      [newName],
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
      'CREATE TABLE OfflineUsers(id INTEGER PRIMARY KEY, fname TEXT, lname TEXT, OfflineUsername TEXT, email TEXT)',
    );
  }

  Future<int> insertOfflineUser(OfflineUser offlineUser) async {
    try {
      return await _database.insert('OfflineUsers', offlineUser.toMap());
    } catch (e) {
      print('Error inserting offline user: $e');
      return -1; // Return a negative value to indicate failure
    }
  }

  Future<List<OfflineUser>> getOfflineUsers() async {
    try {
      final List<Map<String, dynamic>> maps = await _database.query('OfflineUsers');
      return List.generate(maps.length, (i) {
        return OfflineUser(
          id: maps[i]['id'],
          fname: maps[i]['fname'],
          lname: maps[i]['lname'],
          OfflineUsername: maps[i]['OfflineUsername'],
          email: maps[i]['email'],
        );
      });
    } catch (e) {
      print('Error retrieving offline users: $e');
      return []; // Return an empty list if there's an error
    }
  }
}

class OfflineUser {
  final int? id;
  final String fname;
  final String lname;
  final String OfflineUsername;
  final String email;

  OfflineUser({
    this.id,
    required this.fname,
    required this.lname,
    required this.OfflineUsername,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'fname': fname, 'lname': lname, 'OfflineUsername': OfflineUsername, 'email': email};
  }
}
