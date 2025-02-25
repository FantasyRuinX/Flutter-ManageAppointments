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

  Widget appointmentList() {
    List<Event> tempEvents = clientsData.where((item) => item.name == selectedClient).toList();

    return ListView.builder(
      itemCount: tempEvents.length,
      itemBuilder: (BuildContext context,int index) {
        print("Show client $selectedClient appointments current client is ${tempEvents[index]} and index is $index");
          return Text(tempEvents[index].toString());

    },);
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
                    child: Expanded(child: appointmentList())),
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
