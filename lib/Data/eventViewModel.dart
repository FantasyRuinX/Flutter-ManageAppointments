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

  List<Event> getCurrentWeeksEvents() {
    final now = DateTime.now();
    final nowMonday = now.subtract(Duration(days: now.weekday));
    final nowSunday = nowMonday.add(const Duration(days: 6));

    List<Event> dateList = [];

    for (Event item in organisedEvents) {
      List<String> times = item.date.split("-");
      DateTime itemDate = DateTime(int.parse(times[0]),int.parse(times[1]),int.parse(times[2]));

      if (itemDate.isAfter(nowMonday.subtract(const Duration(seconds: 1))) &&
          itemDate.isBefore(nowSunday.add(const Duration(days: 1)))){
        dateList.add(item);
      }
    }

    return dateList;
  }

  Future<double> getTotalWeekAmount() async {
    double total = 0.0;

    for (Event item in getCurrentWeeksEvents()) {
      try {
        total += double.parse(item.rand);
        print(item);
      } catch (err) {
        print('getTotalWeekAmount : $err');
      }
    }

    return total;
  }

  Future<void> writeDB({required Event userData}) async {
    clientDatabase.writeData(userData);
    notifyListeners();
  }

  Future<void> clearEventDB({required Event userData}) async {
    clientDatabase.clearEvent(userData);
    notifyListeners();
  }

  Future<void> updateEventDB({required Event userDataOld, required Event userDataNew}) async {
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
          overlappingEvents.add(item);
        } else {
          //In range of time
          if (currentTimeStart.isAfter(itemTimeStart) &&
              currentTimeEnd.isBefore(itemTimeEnd)) {
            overlappingEvents.add(item);
          }
        }

        //Start is out range but End is in range
        if (currentTimeStart.isBefore(itemTimeStart) &&
            currentTimeEnd.isAfter(itemTimeStart)) {
          overlappingEvents.add(item);
        }

        //Start is in range but End is out range
        if (currentTimeStart.isAfter(itemTimeStart) &&
            currentTimeStart.isBefore(itemTimeEnd) &&
            currentTimeEnd.isAfter(itemTimeEnd)) {
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
