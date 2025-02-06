import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ClientDatabase{

  static Database? db;
  late final String dbName;

  static final ClientDatabase instance = ClientDatabase._constructor();
  ClientDatabase._constructor();

  Future<Database> get database async {
    if (db != null) return db!;
    db = await initDatabase();
    return db!;
  }

  void setName(String name){dbName = name;}

  Future<Database> initDatabase() async{
    
    final dbPath = await getDatabasesPath();
    final path = join(dbPath,'$dbName.db');
    
    final dbTemp = await openDatabase(path,version : 1,
        onCreate: (db,version){db.execute(
        '''
        CREATE TABLE client(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        rand TEXT NOT NULL,
        description TEXT NOT NULL
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
        description TEXT NOT NULL
        )
        '''
      );}
      }

    );
    
    return dbTemp;
  }

}