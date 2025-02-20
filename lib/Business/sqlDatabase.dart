import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:Flutter_ManageAppointments/Data/eventModel.dart';

class ClientDatabase {
  static Database? db;
  final String dbName = "clients";
  String dbNameClient = "DummyName";

  static final ClientDatabase instance = ClientDatabase._constructor();

  ClientDatabase._constructor();

  Future<Database> get database async {
    if (db != null) return db!;
    db = await initDatabase(dbNameClient);
    return db!;
  }

  Future<Database> initDatabase(String tableName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, '$dbName.db');
    //await deleteDatabase(path);
    print("creating table with name $tableName");

    final dbTemp =
    await openDatabase(path, version: 1, onCreate: (db, version) async {
      db.execute('''
        CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        rand TEXT NOT NULL,
        info TEXT NOT NULL,
        location TEXT NOT NULL
        )
        ''');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < newVersion) {
        db.execute('''
        CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
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

  Future<void> writeData(String tableName, Event data) async {
    dbNameClient = tableName;
    final tempDB = await database;

    print("----");
    (await tempDB.query('sqlite_master', columns: ['type', 'name'])).forEach((row) {
      print(row.values.last);
    });

    //Add table if not there
    List<String> dbTables = [];
    (await tempDB.query('sqlite_master', columns: ['type', 'name'])).forEach((row) {
      dbTables.add(row.values.last.toString());
    });

    if(!dbTables.contains(tableName)){
      await tempDB.execute('''
        CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        rand TEXT NOT NULL,
        info TEXT NOT NULL,
        location TEXT NOT NULL
        )
        ''');
      print("Table '$tableName' created.");
    } else {
      print("Table '$tableName' already exists.");
    }

    await tempDB.insert(tableName, data.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String,List<Event>>> readData() async {
    final getDB = await database;
    final tableNames = await getAllTableNames();
    Map<String,List<Event>> userEvents = {};

    tableNames.map((tableName) async {
      var qEvents = await getDB.query(tableName);

      if (qEvents.isEmpty) {
        return [];
      }

      userEvents[tableName];
      qEvents.map((item) {
        userEvents[tableName]?.add(Event(
            date: item['date'].toString(),
            rand: item['rand'].toString(),
            info: item['info'].toString(),
            location: item['location'].toString()));
      });
    });

    return userEvents;
  }

  Future<void> clearDatabase(String tableName) async {
    dbNameClient = tableName;
    final tempDB = await database;
    tempDB.delete(tableName);
  }

  Future<void> getPath() async {
    final dbPath = await getDatabasesPath();
    print(dbPath);
  }

  Future<List<String>> getAllTableNames() async {
    List<String> dbTables = [];
    final getDB = await database;

    (await getDB.query('sqlite_master', columns: ['type', 'name'])).forEach((row) {
      dbTables.add(row.values.last.toString());
    });

    dbTables.remove("android_metadata");
    dbTables.remove("sqlite_sequence");

    return dbTables;
  }

}