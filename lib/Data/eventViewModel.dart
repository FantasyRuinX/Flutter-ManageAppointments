
import 'package:Flutter_ManageAppointments/Business/sqlDatabase.dart';
import 'package:flutter/foundation.dart';
import 'package:Flutter_ManageAppointments/Data/eventModel.dart';

class EventViewModel extends ChangeNotifier{

  final ClientDatabase clientDatabase = ClientDatabase.instance;

  late Events events;

  Future<void> createDB({required String tableName}) async{
    clientDatabase.initDatabase(tableName);
    notifyListeners();
  }

  Future<void> writeDB({required String tableName,required Events userData}) async{
    clientDatabase.writeData(tableName, userData);
    notifyListeners();
  }

  Future<void> readDB({required String tableName}) async{
    events = await clientDatabase.readData(tableName);
    notifyListeners();
  }

  Future<void> clearDB({required String tableName}) async{
    clientDatabase.clearDatabase(tableName);
    notifyListeners();
  }

}