import 'package:Flutter_ManageAppointments/Data/eventViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Data/eventModel.dart';

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

  @override
  void initState() {
    super.initState();
    _focusedDate = DateTime.now();
  }

  void setCurrentItem(BuildContext context, int index) {
    //Show Dialog variables
    String title = "";

    setState(() {
      _selectedItem = index;

      switch (_selectedItem) {
        case 0:
          addAppointment(context);
          break;
        case 1:
          title = "Show Clients";
          break;
        case 2:
          title = "Change Client";
          break;
        case 3:
          title = "Remove Client";
          break;
      }
    });
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

                //Show selected date
                selectedDayPredicate: (day) => isSameDay(_selectedDate, day),

                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDate, selectedDay)) {
                    setState(() {
                      _selectedDate = selectedDay;
                      _focusedDate = focusedDay;
                    });
                  }
                },
                //----------------

                eventLoader: (day) => [1, 2].isNotEmpty ? [1] : [],
              ),
              const SizedBox(height: 10),
              Expanded(child: clientList(context, eventViewModel)),
              const SizedBox(height: 10),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Clients"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.change_circle), label: "Change"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.remove), label: "Remove"),
            ],
            currentIndex: _selectedItem,
            onTap: (i) => setCurrentItem(context, i),
            type: BottomNavigationBarType.fixed,
            //Show all 4 icons because more than 3 makes it invisible
            selectedItemColor: Colors.indigo[900],
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            iconSize: 30,
          ));
    });
  }
}

Widget clientList(BuildContext context, EventViewModel eventViewModel) {
  //List<Events> clientEvents = eventViewModel.events;
  final List<String> clients = ['a', 'b', 'c'];
  clients.add(eventViewModel.clientName);
  return ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: clients.length,
    itemBuilder: (BuildContext context, int index) {
      return SizedBox(
        height: 50,
        child: Text(clients[index]),
      );
    },
  );
}

Future addAppointment(BuildContext context) {
  return showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
            title: const Text('Add new appointment'),
            actions: <Widget>[
              const TextField(

                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter client name")
              ),
              const TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter time")
              ),
              const TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter location")
              ),
              const TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter payment")
              ),
              const TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter description")
              ),
              Center(
                  child: FloatingActionButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Confirm'),
              ))
            ]);
      });
}
