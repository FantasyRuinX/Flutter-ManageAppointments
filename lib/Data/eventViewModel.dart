
import 'package:Flutter_ManageAppointments/Business/sqlDatabase.dart';
import 'package:flutter/foundation.dart';
import 'package:Flutter_ManageAppointments/Data/eventModel.dart';

class EventViewModel extends ChangeNotifier{

  final ClientDatabase clientDatabase = ClientDatabase.instance;

  late Map<String,List<Event>> events;
  late List<String> clientNames;

  Future<void> createDB({required String tableName}) async{
    clientDatabase.initDatabase(tableName);
    notifyListeners();
  }

  Future<void> writeDB({required String tableName,required Event userData}) async{
    clientDatabase.writeData(tableName, userData);
    notifyListeners();
  }

  Future<void> readDB() async{
    events = await clientDatabase.readData();
    notifyListeners();
  }

  Future<void> clearDB({required String tableName}) async{
    clientDatabase.clearDatabase(tableName);
    notifyListeners();
  }

  Future<void> getDBPath() async{
    clientDatabase.getPath();
    notifyListeners();
  }

  Future<void> getClientNames() async{
    clientNames = await clientDatabase.getAllTableNames();
    notifyListeners();
  }

}