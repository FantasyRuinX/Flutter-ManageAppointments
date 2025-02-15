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
  int amount = 0;
  String clientName = "";
  String location = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: <Widget>[
            const SizedBox(height: 5),
            const Text("Please enter all of the following information"),
            SizedBox(
                height: 30,
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
                height: 30,
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
              spacing: 15,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      initialEntryMode: TimePickerEntryMode.dial,
                    );

                    if (time != null) {
                      setState(() {
                        selectedTime = time;
                      });
                    }
                  },
                  child: const Text("Set Time"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? date = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.utc(2050, 1, 1));

                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  },
                  child: const Text("Set Date"),
                ),
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 30,
                children: <Widget>[
                  Text("${selectedTime?.hour} : ${selectedTime?.minute}"),
                  Text("${selectedDate?.day} ${DateFormat.MMMM().format(selectedDate!)}")
                ]),
            SizedBox(
                height: 30,
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

            // TextField(
            //     decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         hintText: "Enter description"))
            FloatingActionButton(
                child: const Text("Submit"),
                onPressed: () {
                  setState(() {
                    clientName = textControllerName.text;
                    location = textControllerLocation.text;
                    amount = int.parse(textControllerAmount.text);
                  });
                  print(
                      "$clientName at $location for $amount on $selectedDate at $selectedTime");
                })
          ]),
    );
  }
}
