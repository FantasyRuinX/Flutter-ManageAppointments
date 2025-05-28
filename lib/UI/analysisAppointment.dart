import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:Flutter_ManageAppointments/Data/eventViewModel.dart';
import 'package:get/get.dart';
import '../Data/eventModel.dart';

class AnalysisAppointment extends StatefulWidget {
  final String title;

  const AnalysisAppointment({super.key, required this.title});

  @override
  State<AnalysisAppointment> createState() => _AnalysisAppointmentState();
}

class _AnalysisAppointmentState extends State<AnalysisAppointment> {
  List<Event> _clientsData = [];
  final List<String> _clientNameList = [];
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
    });
  }

  void setCurrentItem(BuildContext context, EventViewModel eventViewModel, int index) {
    //Show Dialog variables
    setState(() {
      _selectedItem = index;

      switch (_selectedItem) {
        case 0:
          Get.offAndToNamed("/home");
          break;
        case 1:
          Get.offAndToNamed("/listAppointments");
          break;
      }
    });
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
                              width: _screenSize.width,
                              height: _screenSize.height * 0.35,
                              child : BarChart(BarChartData(
                                maxY: 20,
                                barGroups: [
                                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: Colors.blue)]),
                                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10, color: Colors.blue)]),
                                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 14, color: Colors.blue)]),
                                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 15, color: Colors.blue)]),
                                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 13, color: Colors.blue)]),
                                ],
                              ))
                            ),
                      ]))),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.arrow_back), label: "Back"),
                ],
                currentIndex: _selectedItem,
                onTap: (i) => setCurrentItem(context, eventViewModel, i),
                //Show all 4 icons because more than 3 makes it invisible
                type: BottomNavigationBarType.fixed,
                //
                unselectedItemColor: Colors.black,
                selectedItemColor: Colors.black,
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                iconSize: 30,
              )
      ));
    });
  }
}
