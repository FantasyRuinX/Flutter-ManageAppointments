import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:Flutter_ManageAppointments/Data/eventModel.dart';
import 'package:Flutter_ManageAppointments/Data/eventViewModel.dart';

import 'customWidgets.dart';

class AddAppointment extends StatefulWidget {
  final String title;

  const AddAppointment({super.key, required this.title});

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  late EventViewModel eventViewModel;
  TimeOfDay _selectedTimeStart = TimeOfDay.now();
  TimeOfDay _selectedTimeEnd =
      TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1)));
  DateTime? _selectedDate = DateTime.now();

  final TextEditingController _textControllerName = TextEditingController();
  final TextEditingController _textControllerLocation = TextEditingController();
  final TextEditingController _textControllerAmount = TextEditingController();
  final TextEditingController _textControllerDescr = TextEditingController();

  Event? _currentEvent;
  bool _addedEvent = false;
  bool _updateCurrentEvent = false;
  int _selectedItem = 0;
  late Size _screenSize = MediaQuery.sizeOf(context);

  @override
  void initState() {
    super.initState();
    eventViewModel = Provider.of<EventViewModel>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};

    setState(() {
      _currentEvent = args["currentEvent"] ?? null;
      _updateCurrentEvent = args["updateCurrentEvent"] ?? false;

      if (_currentEvent != null && _addedEvent == false) {
        _textControllerName.text = _currentEvent!.name;
        _textControllerLocation.text = _currentEvent!.location;
        _textControllerAmount.text = _currentEvent!.rand;
        _textControllerDescr.text = _currentEvent!.info;

        List<String> startingTime = _currentEvent!.start.split(":");
        List<String> endingTime = _currentEvent!.end.split(":");

        _selectedTimeStart = TimeOfDay(
            hour: int.parse(startingTime[0]),
            minute: int.parse(startingTime[1]));
        _selectedTimeEnd = TimeOfDay(
            hour: int.parse(endingTime[0]), minute: int.parse(endingTime[1]));

        List<String> dates = _currentEvent!.date.split("-");
        _selectedDate = DateTime(
            int.parse(dates[0]), int.parse(dates[1]), int.parse(dates[2]));

        _addedEvent = true;
      }
    });
  }

  Future<void> addEvent(EventViewModel viewmodel) async {
    Event newEvent = Event(
        id: viewmodel.organisedEvents.length,
        name: _textControllerName.text,
        start:
            "${_selectedTimeStart.hour}:${_selectedTimeStart.minute.toString().padLeft(2, '0')}",
        end:
            "${_selectedTimeEnd.hour}:${_selectedTimeEnd.minute.toString().padLeft(2, '0')}",
        date: DateFormat("yyyy-MM-dd").format(_selectedDate!),
        rand: _textControllerAmount.text,
        info: _textControllerDescr.text,
        location: _textControllerLocation.text);

    overlappingMessage(viewmodel, newEvent);
    await viewmodel.writeDB(userData: newEvent);
  }

  Future<void> updateEvent(EventViewModel viewmodel) async {
    Event newEvent = Event(
        id: viewmodel.organisedEvents.length,
        name: _textControllerName.text,
        start:
            "${_selectedTimeStart.hour}:${_selectedTimeStart.minute.toString().padLeft(2, '0')}",
        end:
            "${_selectedTimeEnd.hour}:${_selectedTimeEnd.minute.toString().padLeft(2, '0')}",
        date: DateFormat("yyyy-MM-dd").format(_selectedDate!),
        rand: _textControllerAmount.text,
        info: _textControllerDescr.text,
        location: _textControllerLocation.text);

    overlappingMessage(viewmodel, newEvent);
    await viewmodel.updateEventDB(
        userDataOld: _currentEvent!, userDataNew: newEvent);
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

  void addClientEvent(){
    if (_textControllerName.text.isNotEmpty && _textControllerLocation.text.isNotEmpty &&
        _textControllerDescr.text.isNotEmpty) {
      if (_textControllerAmount.text.isEmpty) {_textControllerAmount.text = "0";}
      if (_currentEvent == null) {addEvent(eventViewModel);}
      else {
        _updateCurrentEvent ? updateEvent(eventViewModel) : addEvent(eventViewModel);
      }
      Get.offAndToNamed("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.sizeOf(context);
    double boxWidth = _screenSize.width * 0.9;
    double boxHeight = _screenSize.height * 0.05;

    return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              centerTitle: true,
              title: Text(widget.title),
            ),

          drawer: customDrawer(),

            body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 25,
                        children: <Widget>[
                      SizedBox(height: _screenSize.height * 0.01),
                      const Text(
                          style: TextStyle(fontSize: 17),
                          "Please enter all of the following information"),
                      SizedBox(
                          height: boxHeight,
                          width: boxWidth,
                          child: TextField(
                              controller: _textControllerName,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.0,
                                    horizontal: 5.0,
                                  ),
                                  border: OutlineInputBorder(),
                                  hintText: "Enter client name"))),
                      SizedBox(
                          height: boxHeight,
                          width: boxWidth,
                          child: TextField(
                              controller: _textControllerLocation,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.0,
                                    horizontal: 5.0,
                                  ),
                                  border: OutlineInputBorder(),
                                  hintText: "Enter location"))),
                      SizedBox(
                          height: _screenSize.height * 0.1,
                          width: boxWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 20,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () async {
                                  _selectedTimeStart = (await showTimePicker(
                                    context: context,
                                    initialTime: _selectedTimeStart,
                                    helpText: "Appointment will start at : ",
                                    initialEntryMode:
                                        TimePickerEntryMode.inputOnly,
                                    builder: (BuildContext context,
                                        Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: true),
                                        child: child!,
                                      );
                                    },
                                  ))!;
                                  _selectedTimeEnd = (await showTimePicker(
                                    context: context,
                                    initialTime: _selectedTimeEnd,
                                    helpText: "Appointment will end at : ",
                                    initialEntryMode:
                                        TimePickerEntryMode.inputOnly,
                                    builder: (BuildContext context,
                                        Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: true),
                                        child: child!,
                                      );
                                    },
                                  ))!;
                                },
                                child: Text(
                                    textAlign: TextAlign.center,
                                    "Set Duration\n${_selectedTimeStart.hour}:${_selectedTimeStart.minute.toString().padLeft(2, '0')} - ${_selectedTimeEnd.hour}:${_selectedTimeEnd.minute.toString().padLeft(2, '0')}"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final DateTime? date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime.utc(2001, 1, 1),
                                      lastDate: DateTime.utc(2100, 1, 1),
                                      initialEntryMode:
                                          DatePickerEntryMode.calendarOnly);

                                  if (date != null) {
                                    setState(() {
                                      _selectedDate = date;
                                    });
                                  }
                                },
                                child: Text(
                                    textAlign: TextAlign.center,
                                    "Set Date\n${_selectedDate!.day} ${DateFormat.MMMM().format(_selectedDate!)}"),
                              ),
                            ],
                          )),
                      SizedBox(
                          height: boxHeight,
                          width: boxWidth,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                                textAlign: TextAlign.center,
                                "Set student email notification"),
                          )),
                      SizedBox(
                          height: boxHeight,
                          width: boxWidth,
                          child: TextField(
                              controller: _textControllerAmount,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.0,
                                    horizontal: 5.0,
                                  ),
                                  border: OutlineInputBorder(),
                                  hintText: "Enter payment amount"))),
                      SizedBox(
                          height: _screenSize.height * 0.1,
                          width: boxWidth,
                          child: TextField(
                            controller: _textControllerDescr,
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
                      SizedBox(
                          height: boxHeight,
                          width: boxWidth,
                          child: ElevatedButton(
                            onPressed: () => addClientEvent(),
                            child: const Text(
                                textAlign: TextAlign.center,
                                "Add Appointment"),
                          )),
                    ])))
    );
  }
}
