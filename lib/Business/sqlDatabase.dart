import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:Flutter_ManageAppointments/Data/eventModel.dart';

class ClientDatabase{

  static Database? db;
  final String dbName = "clients";
  late final String dbNameClient;

  static final ClientDatabase instance = ClientDatabase._constructor();
  ClientDatabase._constructor();

  Future<Database> get database async {
    if (db != null) return db!;
    db = await initDatabase(dbNameClient);
    return db!;
  }

  Future<Database> initDatabase(String tableName) async{
    
    final dbPath = await getDatabasesPath();
    final path = join(dbPath,'$dbName.db');
    
    final dbTemp = await openDatabase(path,version : 1,
        onCreate: (db,version) async {
      db.execute(
        '''
        CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        rand TEXT NOT NULL,
        info TEXT NOT NULL,
        location TEXT NOT NULL
        )
        '''
      );
    },
      onUpgrade: (db,oldVersion,newVersion) async {
      if (oldVersion < newVersion){
      db.execute(
        '''
        CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        rand TEXT NOT NULL,
        info TEXT NOT NULL,
        location TEXT NOT NULL
        )
        '''
      );}
      }

    );
    
    return dbTemp;
  }

  Future<void> writeData(String tableName, Event data) async{
    final tempDB = await database;

    await tempDB.insert(tableName, data.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Event>> readData(String tableName) async{
    final getDB = await database;
    final qEvents = await getDB.query(tableName);

    if (qEvents.isEmpty){return [];}

    List<Event> userEvents = [];

    qEvents.map((item){
      userEvents.add(Event(date: item['date'].toString(),
          rand: item['rand'].toString(),
          info: item['info'].toString(),
          location: item['location'].toString()));
    });

    return userEvents;
  }

  Future<void> clearDatabase(String tableName) async {
    final tempDB = await database;
    tempDB.delete(tableName);
  }

  Future<void> getPath() async{
    final dbPath = await getDatabasesPath();
    print(dbPath);
  }

}