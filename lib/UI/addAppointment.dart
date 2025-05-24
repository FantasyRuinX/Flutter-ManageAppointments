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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};

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

  void setCurrentItem(BuildContext context,EventViewModel eventViewModel,int index) {

    setState(() {
      _selectedItem = index;
    switch(_selectedItem){
      case 0 : if (_textControllerName.text.isNotEmpty &&
          _textControllerLocation.text.isNotEmpty &&
          _textControllerDescr.text.isNotEmpty) {

        if (_textControllerAmount.text.isEmpty)
        {_textControllerAmount.text = "0";}

        if (_currentEvent == null) {
          addEvent(eventViewModel);
        } else {
          if (_updateCurrentEvent) {
            updateEvent(eventViewModel);
          } else {
            addEvent(eventViewModel);
          }
        }

        Navigator.pushNamed(context, "/home");
      }
      break;

      case 1 : Navigator.pushNamed(context, "/home");break;
    }});

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
                      controller: _textControllerName,
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
                      controller: _textControllerLocation,
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
                      _selectedTimeStart = (await showTimePicker(
                        context: context,
                        initialTime: _selectedTimeStart,
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
                      _selectedTimeEnd = (await showTimePicker(
                        context: context,
                        initialTime: _selectedTimeEnd,
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
                        "Set Duration\n${_selectedTimeStart.hour}:${_selectedTimeStart.minute.toString().padLeft(2, '0')} - ${_selectedTimeEnd.hour}:${_selectedTimeEnd.minute.toString().padLeft(2, '0')}"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? date = await showDatePicker(
                          context: context,
                          firstDate: DateTime.utc(2001, 1, 1),
                          lastDate: DateTime.utc(2100, 1, 1),
                          initialEntryMode: DatePickerEntryMode.calendarOnly);

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
              ),
              SizedBox(
                  height: 40,
                  width: 340,
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
                  height: 120,
                  width: 340,
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
              const SizedBox(
                height: 20,
              ),
            ]),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
              BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: "Back"),
            ],
            currentIndex: _selectedItem,
            onTap: (i) => setCurrentItem(context,eventViewModel,i),
            //Show all 4 icons because more than 3 makes it invisible
            type: BottomNavigationBarType.fixed,
            //
            selectedItemColor: Colors.black,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            iconSize: 30,
          )

      );
    });
  }

}
