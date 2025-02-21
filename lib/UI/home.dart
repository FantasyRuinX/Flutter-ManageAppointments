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
  List<Map<String,Event>> clients = [];
  List<String> clientNames = [];

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
    final eventViewModel = Provider.of<EventViewModel>(context,listen: false);
    await eventViewModel.readDB();
    await eventViewModel.getClientNames();
    setState(() {
      clients = eventViewModel.organisedEvents;
      clientNames = eventViewModel.clientNames;
    });
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
      }
    });
  }

  String setOutputEventText(Map<String,Event> event){
    return "${event.keys.first} : ${(event.values.first).date}\n${(event.values.first).info}";
  }

  Widget appointmentList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: clients.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: <Widget>[
            FloatingActionButton.small(
                onPressed: () => setState(() {
                  clients.removeAt(index);
                    }),
                child: const Icon(Icons.clear)),
            Text(setOutputEventText(clients[index])),
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

                //Show selected date
                selectedDayPredicate: (day) => isSameDay(_selectedDate, day),

                onDaySelected: (selectedDay, focusedDay) async {
                  if (!isSameDay(_selectedDate, selectedDay)) {
                    await eventViewModel.readDB();

                    await eventViewModel.getClientNames();
                    setState(() {
                      _selectedDate = selectedDay;
                      _focusedDate = focusedDay;
                      clients = eventViewModel.organisedEvents;
                      clientNames = eventViewModel.clientNames;
                    });
                  }
                },
                //----------------

                eventLoader: (day) => [1, 2].isNotEmpty ? [1] : [],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () async {
                    eventViewModel.clearDB();
                  },
                  child: Icon(Icons.remove)),
              Expanded(child: appointmentList()),
              const SizedBox(height: 10),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Clients"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.remove), label: "Clear database"),
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
