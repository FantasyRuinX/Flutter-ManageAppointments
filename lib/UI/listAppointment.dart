import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Flutter_ManageAppointments/Data/eventViewModel.dart';

class ListAppointment extends StatefulWidget {
  final String title;

  const ListAppointment({super.key, required this.title});

  @override
  State<ListAppointment> createState() => _ListAppointmentState();
}

class _ListAppointmentState extends State<ListAppointment> {
  List<String> clientNames = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async {
    final eventViewModel = Provider.of<EventViewModel>(context, listen: false);
    await eventViewModel.readDB();
    setState(() {
      clientNames = eventViewModel.organisedEvents.map((event) => event.name).toList();
    });
  }

  Widget appointmentList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: clientNames.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: <Widget>[
            FloatingActionButton.small(
                onPressed: () => setState(() {
                      clientNames.removeAt(index);
                    }),
                child: const Icon(Icons.clear)),
            Text(clientNames[index].toString()),
            //Text(event.toString())
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
            automaticallyImplyLeading: false,
            title: Text(widget.title),
          ),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: appointmentList()),
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
              ]));
    });
  }
}
