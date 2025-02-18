import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Flutter_ManageAppointments/Data/eventViewModel.dart';

class ListAppointment extends StatelessWidget {
  final String title;

  const ListAppointment({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventViewModel>(builder: (context, eventViewModel, child) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(title),
          ),
          body: Column(children: <Widget>[
            SizedBox(
                height: 50,
                width: 200,
                child: FloatingActionButton.large(
                    child: const Text(style: TextStyle(fontSize: 17), "Back"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })),
          ]));
    });
  }
}
