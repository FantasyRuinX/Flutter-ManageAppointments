import 'package:Flutter_ManageAppointments/Business/sqlDatabase.dart';
import 'package:flutter/foundation.dart';
import 'package:Flutter_ManageAppointments/Data/eventModel.dart';
import 'package:flutter/material.dart';

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

  Future<List<Event>> overlappingEventTime({required Event userDataNew}) async{

    List<Event> overlappingEvents = [];
    List<String> eventTime0 = userDataNew.start.split(":");
    List<String> eventTime1 = userDataNew.end.split(":");
    TimeOfDay currentTimeStart = TimeOfDay(hour: int.parse(eventTime0[0]), minute: int.parse(eventTime0[1]));
    TimeOfDay currentTimeEnd = TimeOfDay(hour: int.parse(eventTime1[0]), minute: int.parse(eventTime1[1]));

    for (Event item in organisedEvents){
      if (item.date == userDataNew.date){

        print("Event in date");

        List<String> itemTime0 = item.start.split(":");
        List<String> itemTime1 = item.end.split(":");
        TimeOfDay itemTimeStart = TimeOfDay(hour: int.parse(itemTime0[0]), minute: int.parse(itemTime0[1]));
        TimeOfDay itemTimeEnd = TimeOfDay(hour: int.parse(itemTime1[0]), minute: int.parse(itemTime1[1]));

        if (currentTimeStart.isAfter(itemTimeStart) && currentTimeEnd.isBefore(itemTimeEnd)) {//In range of time
          overlappingEvents.add(item);
          }
        if (currentTimeStart.isBefore(itemTimeStart) && currentTimeEnd.isAfter(itemTimeStart)) {//Start is out range but End is in range
          overlappingEvents.add(item);
          }
        if (currentTimeStart.isAfter(itemTimeStart) && currentTimeEnd.isAfter(itemTimeEnd)) {//Start is in range but End is out range
          overlappingEvents.add(item);
        }

      }
    }

    print("Time is overlapping with ${overlappingEvents.length} events");
    return overlappingEvents;
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