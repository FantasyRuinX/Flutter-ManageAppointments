import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:Flutter_ManageAppointments/Data/eventViewModel.dart';
import 'package:get/get.dart';
import '../Data/eventModel.dart';

class ListAppointment extends StatefulWidget {
  final String title;

  const ListAppointment({super.key, required this.title});

  @override
  State<ListAppointment> createState() => _ListAppointmentState();
}

class _ListAppointmentState extends State<ListAppointment> {
  final TextEditingController _txtClientName = TextEditingController();
  List<Event> _clientsData = [];
  final List<String> _clientNameList = [];
  String _selectedClient = "";
  int _selectedItem = 0;
  late Size _screenSize = MediaQuery.sizeOf(context);

  @override
  void initState() {
    super.initState();
    loadClients();
  }

  void loadClients() async {
    final eventViewModel = Provider.of<EventViewModel>(context, listen: false);
    await eventViewModel.readDB();
    setState(() {
      _clientsData = eventViewModel.organisedEvents;

      for (int index = 0; index < _clientsData.length; index++) {
        if (!_clientNameList.contains(_clientsData[index].name)) {
          _clientNameList.add(_clientsData[index].name);
        }
      }
    });
  }

  void setCurrentItem(
      BuildContext context, EventViewModel eventViewModel, int index) {
    //Show Dialog variables
    setState(() {
      _selectedItem = index;

      switch (_selectedItem) {
        case 0:
          Get.offAndToNamed("/home");
          break;
        case 1:
          Get.offAndToNamed("/home");
          //Navigator.pushNamed(context, "/home");
          break;
      }
    });
  }

  String setOutputEventText(Event event) {
    return "${event.date} at ${event.start} to ${event.end}";
  }

  Widget appointmentList(EventViewModel eventViewModel) {
    if (_clientsData.isEmpty) {
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
        _clientsData.where((item) => item.name == _selectedClient).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: tempEvents.length,
      itemBuilder: (BuildContext context, int index) {
        return TextButton(
                style: ButtonStyle(
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2))),
                    backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.inversePrimary)),
                onPressed: () => setState(() {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  side: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 3)),
                              title: Text(tempEvents[index].name),
                              content: Text(
                                  "Location : ${tempEvents[index].location}\nPayment : R${tempEvents[index].rand}\n${tempEvents[index].info}"),
                              insetPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              actionsPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              actions: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
            .animate(delay: (250 + (index * 100)).ms)
            .fadeIn()
            .slideY();
      },
    );
  }

  Widget appointmentNameList() {
    if (_clientsData.isEmpty) {
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
      itemCount: _clientNameList.length,
      itemBuilder: (BuildContext context, int index) {
        return TextButton(
                style: ButtonStyle(
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2))),
                    backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.inversePrimary)),
                onPressed: () => setState(() {
                      _selectedClient = _clientNameList[index];
                    }),
                child: Text(_clientNameList[index]))
            .animate(delay: (250 + (index * 100)).ms)
            .fadeIn()
            .slideY();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.sizeOf(context);

    return Consumer<EventViewModel>(builder: (context, eventViewModel, child) {
      return SafeArea(
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                centerTitle: true,
                automaticallyImplyLeading: false,
                title: Text(widget.title),
              ),
              body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                        SizedBox(
                            height: _screenSize.height * 0.05,
                            child: const Text(
                                style: TextStyle(fontSize: 17),
                                "Please enter or click on client name")),
                        SizedBox(
                            height: _screenSize.width * 0.1,
                            width: _screenSize.width * 0.75,
                            child: TextField(
                                controller: _txtClientName,
                                onSubmitted: (value) {
                                  setState(() {
                                    if (_clientNameList
                                        .contains(_txtClientName.text)) {
                                      _selectedClient = _txtClientName.text;
                                    }
                                  });
                                },
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 5.0),
                                    border: OutlineInputBorder(),
                                    hintText: "Enter Client Name"))),
                        SizedBox(height: _screenSize.height * 0.02),
                        SizedBox(
                            width: _screenSize.width,
                            height: _screenSize.height * 0.25,
                            child: appointmentNameList()),
                        SizedBox(
                            height: _screenSize.height * 0.05,
                            child: Center(
                                child: Text(
                                    style: const TextStyle(fontSize: 17),
                                    _selectedClient.isEmpty
                                        ? "No Selected Clients"
                                        : "Selected Client : $_selectedClient"))),
                        SizedBox(
                            width: _screenSize.width,
                            height: _screenSize.height * 0.3,
                            child: appointmentList(eventViewModel)),
                      ]))),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.stacked_bar_chart),
                      label: "Payment Analytics"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.arrow_back), label: "Back"),
                ],
                currentIndex: _selectedItem,
                onTap: (i) => setCurrentItem(context, eventViewModel, i),
                //Show all 4 icons because more than 3 makes it invisible
                type: BottomNavigationBarType.fixed,
                //
                selectedItemColor: Colors.black,
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                iconSize: 30,
              )));
    });
  }
}
