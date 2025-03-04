import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:Flutter_ManageAppointments/Data/eventModel.dart';

class ClientDatabase {
  static Database? db;
  final String dbName = "clientDatabase";
  String tableName = "clients";

  static final ClientDatabase instance = ClientDatabase._constructor();

  ClientDatabase._constructor();

  Future<Database> get database async {
    if (db != null) return db!;
    db = await initDatabase();
    return db!;
  }

  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, '$dbName.db');

    final dbTemp =
    await openDatabase(path, version: 1, onCreate: (db, version) async {
      db.execute('''
        CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        start TEXT NOT NULL,
        end TEXT NOT NULL,
        date TEXT NOT NULL,
        rand TEXT NOT NULL,
        info TEXT NOT NULL,
        location TEXT NOT NULL
        )
        ''');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < newVersion) {
        db.execute('''
        CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        start TEXT NOT NULL,
        end TEXT NOT NULL,
        date TEXT NOT NULL,
        rand TEXT NOT NULL,
        info TEXT NOT NULL,
        location TEXT NOT NULL
        )
        ''');
      }
    });

    return dbTemp;
  }

  Future<void> writeData(Event data) async {

    final tempDB = await database;
    await tempDB.insert(tableName, data.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

  }

  Future<void> clearEvent(Event data) async {
    final tempDB = await database;

    await tempDB.delete(tableName, where : 'id = ? AND date = ? AND info = ?', whereArgs: [data.id,data.date,data.info]);
  }

  Future<void> updateEvent(Event oldData,Event newData) async {
    final tempDB = await database;

    await tempDB.update(tableName, newData.toJson(), where : 'id = ? AND date = ? AND info = ?', whereArgs: [oldData.id,oldData.date,oldData.info]);
  }

  Future<List<Event>> readData() async {
    final getDB = await database;
    List<Event> userEvents = [];

    var qEvents = await getDB.query(tableName);

    for (var item in qEvents) {
      userEvents.add(Event.fromJson(item));
    }

    return userEvents;
  }

  Future<void> clearDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, '$dbName.db');
    await deleteDatabase(path);
  }


}