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
  List<String> clientNameList = [];
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
      clientsData = eventViewModel.organisedEvents;

      for (int index = 0; index < clientsData.length; index++) {
        if (!clientNameList.contains(clientsData[index].name))
        {clientNameList.add(clientsData[index].name);}
      }
    });
  }

  String setOutputEventText(Event event) {
    return "${event.date} at ${event.start} to ${event.end}";
  }

  Widget appointmentList(EventViewModel eventViewModel) {
    if (clientsData.isEmpty) {
      return const Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
            SizedBox(height: 20),
            Text(style: TextStyle(fontSize: 17), "No Client Data"),
            SizedBox(height: 20)
          ]));
    }

    List<Event> tempEvents =
        clientsData.where((item) => item.name == selectedClient).toList();

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
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Close")),
                                      TextButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                      title: const Text(
                                                          "Removing Event"),
                                                      content: const Text(
                                                          "Are you sure you want to remove this event?"),
                                                      buttonPadding:
                                                      const EdgeInsets.all(
                                                          25),
                                                      actionsOverflowButtonSpacing:
                                                      1000,
                                                      actionsAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                context)
                                                                .pop();
                                                          },
                                                          style: const ButtonStyle(
                                                              textStyle: WidgetStatePropertyAll(
                                                                  TextStyle(
                                                                      fontSize:
                                                                      20))),
                                                          child:
                                                          const Text("No"),
                                                        ),
                                                        TextButton(
                                                            onPressed: () {
                                                              eventViewModel
                                                                  .clearEventDB(
                                                                  userData:
                                                                  tempEvents[
                                                                  index]);
                                                              loadClients();
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                            },
                                                            style: const ButtonStyle(
                                                                textStyle: WidgetStatePropertyAll(
                                                                    TextStyle(
                                                                        fontSize:
                                                                        20))),
                                                            child: const Text(
                                                                "Yes"))
                                                      ]);
                                                });
                                          },
                                          child: const Text("Remove")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.pushNamed(
                                                context, "/addAppointments",
                                                arguments: <String, dynamic>{
                                                  "currentEvent":
                                                  tempEvents[index],
                                                  "updateCurrentEvent": true
                                                });
                                          },
                                          child: const Text("Change")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.pushNamed(
                                                context, "/addAppointments",
                                                arguments: <String, dynamic>{
                                                  "currentEvent":
                                                  tempEvents[index],
                                                  "updateCurrentEvent": false
                                                });
                                          },
                                          child: const Text("Copy")),
                                    ])
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
    if (clientsData.isEmpty) {
      return const Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
            SizedBox(height: 20),
            Text(style: TextStyle(fontSize: 17), "No Clients"),
            SizedBox(height: 20)
          ]));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: clientNameList.length,
      itemBuilder: (BuildContext context, int index) {
        return TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.inversePrimary)),
            onPressed: () => setState(() {
                  selectedClient = clientNameList[index];
                }),
            child: Text(clientNameList[index]));
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
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                const SizedBox(height: 20),
                const Text(
                    style: TextStyle(fontSize: 17),
                    "Please enter or click on client name"),
                const SizedBox(height: 20),
                SizedBox(
                    height: 50,
                    width: MediaQuery.sizeOf(context).width - 100,
                    child: TextField(
                        controller: txtClientName,
                        onSubmitted: (value) {
                          setState(() {
                            if (clientNameList.contains(txtClientName.text)) {
                              selectedClient = txtClientName.text;
                            }
                          });
                        },
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 5.0),
                            border: OutlineInputBorder(),
                            hintText: "Enter Client Name"))),

                Expanded(
                    child: SizedBox(
                        height: 200,
                        width: MediaQuery.sizeOf(context).width - 150,
                        child: appointmentNameList())),
                Expanded(
                    child: SizedBox(
                        height: 200,
                        width: MediaQuery.sizeOf(context).width - 150,
                        child: appointmentList(eventViewModel))),
                const SizedBox(height: 20),
                SizedBox(
                    height: 50,
                    width: 200,
                    child: FloatingActionButton.large(
                        child:
                            const Text(style: TextStyle(fontSize: 17), "Back"),
                        onPressed: () {
                          Navigator.of(context).pushNamed("/home");
                        })),
                    const SizedBox(height: 125),
              ])));
    });
  }
}
