import 'package:Flutter_ManageAppointments/Business/sqlDatabase.dart';
import 'package:flutter/foundation.dart';
import 'package:Flutter_ManageAppointments/Data/eventModel.dart';

class EventViewModel extends ChangeNotifier{

  final ClientDatabase clientDatabase = ClientDatabase.instance;

  late List<Event> organisedEvents;

  Future<void> createDB() async{
    clientDatabase.initDatabase();
    notifyListeners();
  }

  Future<void> writeDB({required Event userData}) async{
    clientDatabase.writeData(userData);
    notifyListeners();
  }

  Future<void> clearEventDB({required Event userData}) async{
    clientDatabase.clearEvent(userData);
    notifyListeners();
  }

  Future<void> updateEventDB({required Event userDataOld,required Event userDataNew}) async{
    clientDatabase.updateEvent(userDataOld,userDataNew);
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

}