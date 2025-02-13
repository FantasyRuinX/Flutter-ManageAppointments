import 'package:flutter/material.dart';

class AddAppointment extends StatefulWidget {
  final String title;
  const AddAppointment({super.key,required this.title});

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {

  TimeOfDay? selectedTime = TimeOfDay.now();

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
            const SizedBox(
                height: 30,
                width: 300,
                child: TextField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0.0,
                          horizontal: 50.0,
                        ),
                        border: OutlineInputBorder(),
                        hintText: "Enter client name"))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      initialEntryMode: TimePickerEntryMode.dial,
                    );

                    if(time != null){
                      setState((){
                        selectedTime = time;
                      });
                    }

                  },
                  child : Text(selectedTime!.format(context)),
                )
              ],
            ),
            // SizedBox(
            //     height: 30, width : 300,
            //     child : TextField(
            //         decoration: InputDecoration(
            //             contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0,),
            //             border: OutlineInputBorder(),
            //             hintText: "Enter location"))),
            // SizedBox(
            //     height: 30, width : 300,
            //     child : TextField(
            //         decoration: InputDecoration(
            //             contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0,),
            //             border: OutlineInputBorder(),
            //             hintText: "Enter payment amount"))),
            // TextField(
            //     decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         hintText: "Enter description"))
          ]),
    );
  }
}


