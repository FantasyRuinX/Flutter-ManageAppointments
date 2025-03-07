import 'package:Flutter_ManageAppointments/Data/eventModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Flutter_ManageAppointments/Data/eventViewModel.dart';
import 'package:table_calendar/table_calendar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? _selectedDate;
  DateTime _focusedDate = DateTime.now();
  int _selectedItem = 0;
  List<Event> clients = [];
  List<String> clientDates = [];

  @override
  void initState() {
    super.initState();
    _focusedDate = DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  Future<void> loadData() async {
    final eventViewModel = Provider.of<EventViewModel>(context, listen: false);
    await eventViewModel.readDB();
    setState(() {
      clientDates.clear();
      clients = eventViewModel.organisedEvents;

      for (Event event in clients) {
        clientDates.add(event.date);
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
          Navigator.pushNamed(context, "/addAppointments",
              arguments: <String, dynamic>{"updateEvent": null});
          break;
        case 1:
          Navigator.pushNamed(context, "/listAppointments");
          break;
      }
    });
  }

  String setOutputEventText(Event event) {
    return "${event.name} at ${event.start} to ${event.end}";
  }

  Widget appointmentList(EventViewModel eventViewModel) {
    List<Event> clientsOnDay = [];
    for (Event event in clients) {
      if (event.date.split("T")[0] == _focusedDate.toString().split(" ")[0]) {
        clientsOnDay.add(event);
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: clientsOnDay.length,
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
                              title: Text(clientsOnDay[index].name),
                              content: Text(
                                  "Location : ${clientsOnDay[index].location}\nPayment : R${clientsOnDay[index].rand}\n${clientsOnDay[index].info}"),
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
                                                                          clientsOnDay[
                                                                              index]);
                                                              loadData();
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
                                                      clientsOnDay[index],
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
                                                      clientsOnDay[index],
                                                  "updateCurrentEvent": false
                                                });
                                          },
                                          child: const Text("Copy")),
                                    ])
                              ],
                            );
                          });
                    }),
                child: Text(setOutputEventText(clientsOnDay[index])))
          ],
        );
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
            title: Text(widget.title),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TableCalendar(
                focusedDay: _focusedDate,
                firstDay: DateTime.utc(2001, 1, 1),
                lastDay: DateTime.utc(2050, 1, 1),
                headerStyle: const HeaderStyle(
                    titleCentered: true, formatButtonVisible: false),

                //Show selected date
                selectedDayPredicate: (day) => isSameDay(_selectedDate, day),

                onDaySelected: (selectedDay, focusedDay) async {
                  if (!isSameDay(_selectedDate, selectedDay)) {
                    await eventViewModel.readDB();
                    setState(() {
                      _selectedDate = selectedDay;
                      _focusedDate = focusedDay;
                      clients = eventViewModel.organisedEvents;
                    });
                  }
                },
                //----------------

                eventLoader: (day) =>
                    clientDates.contains(day.toString().split(" ")[0])
                        ? [1]
                        : [],
              ),
              const SizedBox(height: 10),
              Expanded(child: appointmentList(eventViewModel)),
              const SizedBox(height: 10),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Clients"),
            ],
            currentIndex: _selectedItem,
            onTap: (i) => setCurrentItem(context, eventViewModel, i),
            type: BottomNavigationBarType.fixed,
            //Show all 4 icons because more than 3 makes it invisible
            selectedItemColor: Colors.indigo[900],
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            iconSize: 30,
          ));
    });
  }
}
