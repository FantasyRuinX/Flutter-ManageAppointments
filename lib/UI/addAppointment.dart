import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:Flutter_ManageAppointments/Data/eventModel.dart';
import 'package:Flutter_ManageAppointments/Data/eventViewModel.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AddAppointment extends StatefulWidget {
  final String title;

  const AddAppointment({super.key, required this.title});

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  TimeRange? selectedTime = TimeRange(
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1))));
  DateTime? selectedDate = DateTime.now();

  TextEditingController textControllerName = TextEditingController();
  TextEditingController textControllerLocation = TextEditingController();
  TextEditingController textControllerAmount = TextEditingController();
  TextEditingController textControllerDescr = TextEditingController();
  int amount = 0;
  String clientName = "";
  String location = "";
  String description = "";

  Event? updateEvent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    setState(() {
      updateEvent = args["updateEvent"] ?? null;
    });
    print(args["updateEvent"]);
  }

  Future<void> addEvent(EventViewModel viewmodel, String name, String location, int amount, String descr, TimeOfDay time, DateTime date) async {
    Event newEvent = Event(
        id: viewmodel.organisedEvents.length,
        name: name,
        start: selectedTime!.startTime.format(context),
        end: selectedTime!.endTime.format(context),
        date: DateFormat("yyyy-MM-dd").format(selectedDate!),
        rand: amount.toString(),
        info: descr,
        location: location);
    await viewmodel.writeDB(userData: newEvent);
  }

  void setDuration() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Enter duration"),
            content: Row(children: [
              SizedBox(
                  height: 50,
                  width: 50,
                  child: TextField(
                      controller: textControllerAmount,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0,
                            horizontal: 5.0,
                          ),
                          border: OutlineInputBorder(),
                          hintText: "Enter payment amount")))
            ]),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK")),
            ],
          );
        });
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
                      final TimeRange? timeRange = await showTimeRangePicker(
                          use24HourFormat: true,
                          end: TimeOfDay.fromDateTime(
                              DateTime.now().add(const Duration(hours: 1))),
                          context: context);
                    },
                    child: Text(
                        textAlign: TextAlign.center,
                        "Set Duration\n${selectedTime!.startTime.format(context)} - ${selectedTime!.endTime.format(context)}"),
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
                        setState(() {
                          clientName = textControllerName.text;
                          location = textControllerLocation.text;
                          amount = int.parse(textControllerAmount.text);
                          description = textControllerDescr.text;
                        });
                        addEvent(
                            eventViewModel,
                            clientName,
                            location,
                            amount,
                            description,
                            selectedTime!.startTime,
                            selectedDate!);
                        Navigator.of(context).pushNamed("/home");
                      })),
              SizedBox(
                  height: 50,
                  width: 200,
                  child: FloatingActionButton.large(
                      child: const Text(style: TextStyle(fontSize: 17), "Back"),
                      onPressed: () {
                        Navigator.of(context).pushNamed("/home");
                      })),
            ]),
      );
    });
  }
}
