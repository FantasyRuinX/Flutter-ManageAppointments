import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Flutter_ManageAppointments/Data/eventViewModel.dart';

import '../Data/eventModel.dart';

class ListAppointment extends StatefulWidget {
  final String title;

  const ListAppointment({super.key, required this.title});

  @override
  State<ListAppointment> createState() => _ListAppointmentState();
}

class _ListAppointmentState extends State<ListAppointment> {
  TextEditingController txtClientName = TextEditingController();
  List<Event> clientsData = [];
  String selectedClient = "";

  @override
  void initState() {
    super.initState();
    loadClients();
  }

  void loadClients() async {
    final eventViewModel = Provider.of<EventViewModel>(context, listen: false);
    await eventViewModel.readDB();
    setState(() {
      clientsData= eventViewModel.organisedEvents;
    });
  }

  String setOutputEventText(Event event) {
    return "${event.date} at ${event.start} to ${event.end}";
  }

  Widget appointmentList(EventViewModel eventViewModel) {
    List<Event> tempEvents = clientsData.where((item) => item.name == selectedClient).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: tempEvents.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: <Widget>[
            TextButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.inversePrimary)),
                onPressed: () => setState(() {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(tempEvents[index].name),
                          content: Text(
                              "Location : ${tempEvents[index].location}\nPayment : R${tempEvents[index].rand}\n${tempEvents[index].info}"),
                          buttonPadding: const EdgeInsets.all(20),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Close")),
                            TextButton(
                                onPressed: () {
                                  eventViewModel.clearEventDB(userData: tempEvents[index]);
                                  loadClients();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Remove")),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.pushNamed(context, "/addAppointments",arguments: <String,dynamic>{"currentEvent" : tempEvents[index]});
                                },
                                child: const Text("Change")),
                          ],
                        );
                      });
                }),
                child: Text(setOutputEventText(tempEvents[index])))
          ],
        );
      },
    );

  }



  Widget appointmentNameList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: clientsData.length,
      itemBuilder: (BuildContext context, int index) {
        return TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.inversePrimary)),
            onPressed: () => setState(() {selectedClient = clientsData[index].name;}),
            child: Text(clientsData[index].name));
      },
    );
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
          body: Center(child : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 25),
                SizedBox(
                    height: 50,
                    width: MediaQuery.sizeOf(context).width - 100,
                    child: TextField(
                        controller: txtClientName,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 5.0),
                            border: OutlineInputBorder(),
                            hintText: "Enter Client Name"))),
                SizedBox(
                    height: 200,
                    width: MediaQuery.sizeOf(context).width - 200,
                    child: Expanded(child: appointmentNameList())),
                SizedBox(
                    height: 200,
                    width: MediaQuery.sizeOf(context).width - 200,
                    child: Expanded(child: appointmentList(eventViewModel))),
                SizedBox(
                    height: 50,
                    width: 200,
                    child: FloatingActionButton.large(
                        child:
                            const Text(style: TextStyle(fontSize: 17), "Back"),
                        onPressed: () {
                          Navigator.of(context).pushNamed("/home");
                        })),
                const SizedBox(
                  height: 50,
                  width: 200,
                )
              ])));
    });
  }
}
