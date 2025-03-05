import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:Flutter_ManageAppointments/Data/eventModel.dart';
import 'package:Flutter_ManageAppointments/Data/eventViewModel.dart';

class AddAppointment extends StatefulWidget {
  final String title;

  const AddAppointment({super.key, required this.title});

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {

  TimeOfDay selectedTimeStart = TimeOfDay.now();
  TimeOfDay selectedTimeEnd = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1)));
  DateTime? selectedDate = DateTime.now();

  TextEditingController textControllerName = TextEditingController();
  TextEditingController textControllerLocation = TextEditingController();
  TextEditingController textControllerAmount = TextEditingController();
  TextEditingController textControllerDescr = TextEditingController();

  Event? currentEvent;
  List<Event> allEvents = [];
  bool addedEvent = false;
  bool updateCurrentEvent = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};

    loadData();

    setState(() {
      currentEvent = args["currentEvent"] ?? null;
      updateCurrentEvent = args["updateCurrentEvent"] ?? false;

      if (currentEvent != null && addedEvent == false) {
        textControllerName.text = currentEvent!.name;
        textControllerLocation.text = currentEvent!.location;
        textControllerAmount.text = currentEvent!.rand;
        textControllerDescr.text = currentEvent!.info;

        List<String> startingTime = currentEvent!.start.split(":");
        List<String> endingTime = currentEvent!.end.split(":");

        selectedTimeStart = TimeOfDay(
                hour: int.parse(startingTime[0]),
                minute: int.parse(startingTime[1]));
      selectedTimeEnd =  TimeOfDay(
                hour: int.parse(endingTime[0]),
                minute: int.parse(endingTime[1]));

        List<String> dates = currentEvent!.date.split("-");
        selectedDate = DateTime(
            int.parse(dates[0]), int.parse(dates[1]), int.parse(dates[2]));

        addedEvent = true;
      }
    });
  }

  Future<void> loadData() async {
    final eventViewModel = Provider.of<EventViewModel>(context, listen: false);
    await eventViewModel.readDB();
    setState(() {
      allEvents = eventViewModel.organisedEvents;
    });
  }

  Future<void> addEvent(EventViewModel viewmodel) async {
    Event newEvent = Event(
        id: viewmodel.organisedEvents.length,
        name: textControllerName.text,
        start:
            "${selectedTimeStart.hour}:${selectedTimeStart.minute.toString().padLeft(2, '0')}",
        end:
            "${selectedTimeEnd.hour}:${selectedTimeEnd.minute.toString().padLeft(2, '0')}",
        date: DateFormat("yyyy-MM-dd").format(selectedDate!),
        rand: textControllerAmount.text,
        info: textControllerDescr.text,
        location: textControllerLocation.text);

    overlappingMessage(viewmodel, newEvent);
    await viewmodel.writeDB(userData: newEvent);
  }

  Future<void> updateEvent(EventViewModel viewmodel) async {
    Event newEvent = Event(
        id: viewmodel.organisedEvents.length,
        name: textControllerName.text,
        start:
            "${selectedTimeStart.hour}:${selectedTimeStart.minute.toString().padLeft(2, '0')}",
        end:
            "${selectedTimeEnd.hour}:${selectedTimeEnd.minute.toString().padLeft(2, '0')}",
        date: DateFormat("yyyy-MM-dd").format(selectedDate!),
        rand: textControllerAmount.text,
        info: textControllerDescr.text,
        location: textControllerLocation.text);

    overlappingMessage(viewmodel, newEvent);
    await viewmodel.updateEventDB(
        userDataOld: currentEvent!, userDataNew: newEvent);
  }

  Future<void> overlappingMessage(EventViewModel viewmodel, userEvent) async {
    List<Event> overlappingEvents = await viewmodel.overlappingEventTime(
        userDataNew: userEvent); //Testing purposes
    String overlappingOutput = "";

    for (Event item in overlappingEvents) {
      overlappingOutput += "${item.name} from ${item.start} to ${item.end} \n";
    }

    if (overlappingEvents.isNotEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text("Overlapping Events"),
                content: Text(overlappingOutput),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Close"))
                ]);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventViewModel>(builder: (context, eventViewModel, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(widget.title),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 25,
            children: <Widget>[
              const SizedBox(height: 5),
              const Text(
                  style: TextStyle(fontSize: 17),
                  "Please enter all of the following information"),
              SizedBox(
                  height: 40,
                  width: 340,
                  child: TextField(
                      controller: textControllerName,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0,
                            horizontal: 5.0,
                          ),
                          border: OutlineInputBorder(),
                          hintText: "Enter client name"))),
              SizedBox(
                  height: 40,
                  width: 340,
                  child: TextField(
                      controller: textControllerLocation,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0,
                            horizontal: 5.0,
                          ),
                          border: OutlineInputBorder(),
                          hintText: "Enter location"))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {

                      selectedTimeStart = (await showTimePicker(
                        context: context,
                        initialTime: selectedTimeStart ,
                        helpText: "Appointment will start at : ",
                        initialEntryMode: TimePickerEntryMode.inputOnly,
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      ))!;
                      selectedTimeEnd = (await showTimePicker(
                        context: context,
                        initialTime: selectedTimeEnd,
                        helpText: "Appointment will end at : ",
                        initialEntryMode: TimePickerEntryMode.inputOnly,
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      ))!;
                    },
                    child: Text(
                        textAlign: TextAlign.center,
                        "Set Duration\n${selectedTimeStart.hour}:${selectedTimeStart.minute.toString().padLeft(2, '0')} - ${selectedTimeEnd.hour}:${selectedTimeEnd.minute.toString().padLeft(2, '0')}"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? date = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.utc(2050, 1, 1),
                          initialEntryMode: DatePickerEntryMode.calendarOnly);

                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    },
                    child: Text(
                        textAlign: TextAlign.center,
                        "Set Date\n${selectedDate!.day} ${DateFormat.MMMM().format(selectedDate!)}"),
                  ),
                ],
              ),
              SizedBox(
                  height: 40,
                  width: 340,
                  child: TextField(
                      controller: textControllerAmount,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0,
                            horizontal: 5.0,
                          ),
                          border: OutlineInputBorder(),
                          hintText: "Enter payment amount"))),
              SizedBox(
                  height: 120,
                  width: 340,
                  child: TextField(
                    controller: textControllerDescr,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0.0,
                          horizontal: 5.0,
                        ),
                        border: OutlineInputBorder(),
                        hintText: "Enter appointment description"),
                  )),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 50,
                  width: 200,
                  child: FloatingActionButton.large(
                      child:
                          const Text(style: TextStyle(fontSize: 17), "Submit"),
                      onPressed: () {
                        if (currentEvent == null) {
                          addEvent(eventViewModel);
                        } else {
                          if (updateCurrentEvent) {
                            updateEvent(eventViewModel);
                          }else{
                            addEvent(eventViewModel);
                          }
                        }

                        Navigator.of(context).pop();
                      })),
              SizedBox(
                  height: 50,
                  width: 200,
                  child: FloatingActionButton.large(
                      child: const Text(style: TextStyle(fontSize: 17), "Back"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })),
            ]),
      );
    });
  }
}
