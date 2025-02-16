import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddAppointment extends StatefulWidget {
  final String title;

  const AddAppointment({super.key, required this.title});

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  TimeOfDay? selectedTime = TimeOfDay.now();
  DateTime? selectedDate = DateTime.now();

  TextEditingController textControllerName = TextEditingController();
  TextEditingController textControllerLocation = TextEditingController();
  TextEditingController textControllerAmount = TextEditingController();
  TextEditingController textControllerDescr = TextEditingController();
  int amount = 0;
  String clientName = "";
  String location = "";
  String description = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        leading: null,
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
              spacing: 40,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      initialEntryMode: TimePickerEntryMode.inputOnly,
                    );

                    if (time != null) {
                      setState(() {
                        selectedTime = time;
                      });
                    }
                  },
                  child: Text(
                      textAlign: TextAlign.center,
                      "Set Time\n${selectedTime?.hour} : ${selectedTime?.minute}"),
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
                        child: const Text(style: TextStyle(fontSize: 17),"Submit"),
                        onPressed: () {
                          setState(() {
                            clientName = textControllerName.text;
                            location = textControllerLocation.text;
                            amount = int.parse(textControllerAmount.text);
                          });
                          print(
                              "$clientName at $location for $amount on $selectedDate at $selectedTime");
                        })),
            SizedBox(
                height: 50,
                width: 200,
                child: FloatingActionButton.large(
                    child: const Text(style: TextStyle(fontSize: 17),"Back"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })),
          ]),
    );
  }
}
