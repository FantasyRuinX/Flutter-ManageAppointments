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
  List<String> clients = ['a', 'b', 'c'];

  @override
  void initState() {
    super.initState();
    _focusedDate = DateTime.now();
  }

  void setCurrentItem(BuildContext context, int index) {
    //Show Dialog variables
    setState(() {
      _selectedItem = index;

      switch (_selectedItem) {
        case 0:
          Navigator.pushNamed(context, "/addAppointments");
          break;
        case 1:
          Navigator.pushNamed(context, "/listAppointments");
          break;
        case 2:
          Navigator.pushNamed(context, "/changeAppointments");
          break;
        case 3:
          Navigator.pushNamed(context, "/removeAppointments");
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
              Expanded(
                  child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: clients.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 5,
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: () => setState(() {
                                clients.removeAt(index);
                              }),
                          child: const Icon(Icons.clear)),
                      Text(clients[index])
                    ],
                  );
                },
              )),
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
