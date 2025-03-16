import 'package:Flutter_ManageAppointments/Business/sqlDatabase.dart';
import 'package:flutter/foundation.dart';
import 'package:Flutter_ManageAppointments/Data/eventModel.dart';
import 'package:flutter/material.dart';

class EventViewModel extends ChangeNotifier {
  final ClientDatabase clientDatabase = ClientDatabase.instance;

  late List<Event> organisedEvents;

  Future<void> createDB() async {
    clientDatabase.initDatabase();
    notifyListeners();
  }

  Future<void> writeDB({required Event userData}) async {
    clientDatabase.writeData(userData);
    notifyListeners();
  }

  Future<void> clearEventDB({required Event userData}) async {
    clientDatabase.clearEvent(userData);
    notifyListeners();
  }

  Future<void> updateEventDB(
      {required Event userDataOld, required Event userDataNew}) async {
    clientDatabase.updateEvent(userDataOld, userDataNew);
    notifyListeners();
  }

  Future<List<Event>> overlappingEventTime({required Event userDataNew}) async {
    List<Event> overlappingEvents = [];
    List<String> eventTime0 = userDataNew.start.split(":");
    List<String> eventTime1 = userDataNew.end.split(":");
    TimeOfDay currentTimeStart = TimeOfDay(
        hour: int.parse(eventTime0[0]), minute: int.parse(eventTime0[1]));
    TimeOfDay currentTimeEnd = TimeOfDay(
        hour: int.parse(eventTime1[0]), minute: int.parse(eventTime1[1]));

    for (Event item in organisedEvents) {
      if (item.date == userDataNew.date) {
        List<String> itemTime0 = item.start.split(":");
        List<String> itemTime1 = item.end.split(":");
        TimeOfDay itemTimeStart = TimeOfDay(
            hour: int.parse(itemTime0[0]), minute: int.parse(itemTime0[1]));
        TimeOfDay itemTimeEnd = TimeOfDay(
            hour: int.parse(itemTime1[0]), minute: int.parse(itemTime1[1]));

        //Skip same event
        if (userDataNew == item) continue;

        //Same time
        if (currentTimeStart.isAtSameTimeAs(itemTimeStart) &&
            currentTimeEnd.isAtSameTimeAs(itemTimeEnd)) {
          print("Same time");
          overlappingEvents.add(item);
        } else {
          //In range of time
          if (currentTimeStart.isAfter(itemTimeStart) &&
              currentTimeEnd.isBefore(itemTimeEnd)) {
            print("In range of time");
            overlappingEvents.add(item);
          }
        }

        //Start is out range but End is in range
        if (currentTimeStart.isBefore(itemTimeStart) &&
            currentTimeEnd.isAfter(itemTimeStart)) {
          print("Start is out range but End is in range");
          overlappingEvents.add(item);
        }

        //Start is in range but End is out range
        if (currentTimeStart.isAfter(itemTimeStart) &&
            currentTimeStart.isBefore(itemTimeEnd) &&
            currentTimeEnd.isAfter(itemTimeEnd)) {
          print("Start is in range but End is out range");
          overlappingEvents.add(item);
        }
      }
    }

    return overlappingEvents;
  }

  Future<void> readDB() async {
    organisedEvents = await clientDatabase.readData();
    notifyListeners();
  }

  Future<void> clearDB() async {
    clientDatabase.clearDatabase();
    notifyListeners();
  }
}
