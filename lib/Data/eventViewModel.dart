import 'package:Flutter_ManageAppointments/Business/sqlDatabase.dart';
import 'package:flutter/foundation.dart';
import 'package:Flutter_ManageAppointments/Data/eventModel.dart';

class EventViewModel extends ChangeNotifier{

  final ClientDatabase clientDatabase = ClientDatabase.instance;

  late List<Map<String,Event>> organisedEvents;
  late List<String> clientNames;

  Future<void> createDB({required String tableName}) async{
    clientDatabase.initDatabase(tableName);
    notifyListeners();
  }

  Future<void> writeDB({required String tableName,required Event userData}) async{
    //TODO : error when adding a space or numbers to the name, sql doesn't allow that
    clientDatabase.writeData(tableName, userData);
    notifyListeners();
  }

  Future<void> readDB() async{
    organisedEvents = await clientDatabase.readData();
    notifyListeners();
  }

  Future<void> clearDB() async{
    clientDatabase.clearDatabase();
    notifyListeners();
  }

  Future<void> getClientNames() async{
    clientNames = await clientDatabase.getAllTableNames();
    notifyListeners();
  }

}