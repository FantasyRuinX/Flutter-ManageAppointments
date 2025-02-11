import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:Flutter_ManageAppointments/Data/eventModel.dart';

class ClientDatabase{

  static Database? db;
  late final String dbNameClient;

  static final ClientDatabase instance = ClientDatabase._constructor();
  ClientDatabase._constructor();

  Future<Database> get database async {
    if (db != null) return db!;
    db = await initDatabase();
    return db!;
  }

  void setName(String name){dbNameClient = name;}

  Future<Database> initDatabase() async{
    
    final dbPath = await getDatabasesPath();
    final path = join(dbPath,'$dbNameClient.db');
    
    final dbTemp = await openDatabase(path,version : 1,
        onCreate: (db,version) async {
      db.execute(
        '''
        CREATE TABLE client(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        rand TEXT NOT NULL,
        info TEXT NOT NULL
        )
        '''
      );
    },
      onUpgrade: (db,oldVersion,newVersion) async {
      if (oldVersion < newVersion){
      db.execute(
        '''
        CREATE TABLE client(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        rand TEXT NOT NULL,
        info TEXT NOT NULL
        )
        '''
      );}
      }

    );
    
    return dbTemp;
  }

  Future<void> writeData({required Events data}) async{
    final tempDB = await database;

    await tempDB.insert('client', data.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> clearDatabase() async {
    final tempDB = await database;
    tempDB.delete('client');
  }

}