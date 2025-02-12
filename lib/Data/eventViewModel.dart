
import 'package:Flutter_ManageAppointments/Business/sqlDatabase.dart';
import 'package:flutter/foundation.dart';
import 'package:Flutter_ManageAppointments/Data/eventModel.dart';

class EventViewModel extends ChangeNotifier{

  final ClientDatabase clientDatabase = ClientDatabase.instance;
  String clientName = "TempName";

  late Events events;

  Future<void> createDB() async{
    clientDatabase.initDatabase();
    notifyListeners();
  }

  Future<void> writeDB(Events userData) async{
    clientDatabase.writeData(data: userData);
    notifyListeners();
  }

  Future<void> readDB() async{
    events = await clientDatabase.readData();
    notifyListeners();
  }

  Future<void> clearDB() async{
    clientDatabase.clearDatabase();
    notifyListeners();
  }

}