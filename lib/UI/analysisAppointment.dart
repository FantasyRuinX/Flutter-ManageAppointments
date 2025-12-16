import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:Flutter_ManageAppointments/Data/eventViewModel.dart';
import 'package:get/get.dart';
import '../Data/eventModel.dart';
import 'package:intl/intl.dart';

class AnalysisAppointment extends StatefulWidget {
  final String title;

  const AnalysisAppointment({super.key, required this.title});

  @override
  State<AnalysisAppointment> createState() => _AnalysisAppointmentState();
}

class _AnalysisAppointmentState extends State<AnalysisAppointment> {
  late EventViewModel eventViewModel;

  final TextEditingController _txtClientName = TextEditingController();
  List<Event> _clientsData = [];
  final List<String> _clientNameList = [];
  double _clientAmount = 0.0;
  double _biggestClientAmount = 0.0;

  DateTime _currentWeekDateAmount = DateTime.now();
  DateTime nowMonday = DateTime.now();
  DateTime nowSunday = DateTime.now();
  List<double> _currentWeeksAmount = [];

  String _selectedClient = "";
  int _selectedItem = 0;
  late Size _screenSize = MediaQuery.sizeOf(context);

  @override
  void initState() {
    super.initState();
    eventViewModel = Provider.of<EventViewModel>(context, listen: false);
    loadClients();
  }

  void loadClients() async {
    await eventViewModel.readDB();
    setChartData();

    setState(() {
      _clientsData = eventViewModel.organisedEvents;

      for (int index = 0; index < _clientsData.length; index++) {
        if (!_clientNameList.contains(_clientsData[index].name)) {
          _clientNameList.add(_clientsData[index].name);
        }
      }
    });
  }

  void setChartData() async {
    _currentWeeksAmount = await eventViewModel.getCurrentWeekAmounts(_currentWeekDateAmount);
    _biggestClientAmount = _currentWeeksAmount.reduce((a, b) => a > b ? a : b);

    nowMonday = _currentWeekDateAmount.subtract(Duration(days: _currentWeekDateAmount.weekday));
    nowSunday = nowMonday.add(const Duration(days: 6));

    setState(() {
      _clientAmount = _currentWeeksAmount.fold(0.0, (a,b) => a + b);
    });
  }

  String dateToString(DateTime date){
    return DateFormat('dd MMM yy').format(date);
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

  Widget appointmentNameList(double width, double height) {
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

    return SizedBox(
        width: width,
        height: height,
        child: ListView.builder(
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
      ));
  }

  Widget analysisChart(double width, double height) {

    List<BarChartGroupData> weekData = [];
    for (int i = 0; i < 7; i++){
      if (_currentWeeksAmount.length < 7){_currentWeeksAmount.add(0.0);}
      weekData.add(
          BarChartGroupData(
              x: i,
              barRods: [BarChartRodData(
                  borderRadius: BorderRadius.circular(4),
                  width: 20,
                  toY: _currentWeeksAmount[i],
                  color: Colors.blue)]));
    }

    return SizedBox(
        width: _screenSize.width,
        height: _screenSize.height * 0.3,
        child: Center(child:
              BarChart(BarChartData(
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  List<String> weekNames = ["Mon","Tue","Wed","Thr","Fri","Sat","Sun"];
                  return SideTitleWidget(meta: meta, child: Text(weekNames[value.toInt()]));
                },
              )),
            ),
            maxY: _biggestClientAmount + (_biggestClientAmount * 0.5),
            barGroups: weekData,
          ))
        ));
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
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
                          height: _screenSize.height * 0.03,
                          child: const Text(style: TextStyle(fontSize: 17),
                              "Please enter or click on client name")),
                      SizedBox(height: _screenSize.height * 0.02),
                      analysisChart(_screenSize.width,_screenSize.height * 0.3),
                      SizedBox(height: _screenSize.height * 0.01),
                      selectWeek(_screenSize.width * 0.075,_screenSize.height * 0.075),
                      SizedBox(height: _screenSize.height * 0.01),

                      SizedBox(
                          height: _screenSize.height * 0.05,
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
                      appointmentNameList(_screenSize.width,_screenSize.height * 0.25),
                    ]))),
            bottomNavigationBar: bottomBarOptions());
  }

  Widget selectWeek(double width, double height) {
    return SizedBox(
        height: height,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: width,
            children: [
              IconButton(onPressed: (){
                _currentWeekDateAmount = _currentWeekDateAmount.subtract(Duration(days: 7));
                setChartData();
              }, icon: const Icon(Icons.arrow_back))
              ,Text(
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 17),
                  "${dateToString(nowMonday)} - ${dateToString(nowSunday)}\nR$_clientAmount"),
              IconButton(onPressed: (){
                _currentWeekDateAmount = _currentWeekDateAmount.add(Duration(days: 7));
                setChartData();
              }, icon: const Icon(Icons.arrow_forward))]
        ));
  }

  Widget bottomBarOptions(){

    void setCurrentItem(BuildContext context, EventViewModel eventViewModel, int index) {
      //Show Dialog variables
      setState(() {
        _selectedItem = index;
        switch (_selectedItem) {
          case 0:Get.offAndToNamed("/addAppointments",arguments: <String, dynamic>{"updateEvent": null});break;
          case 1:Get.offAndToNamed("/home");break;
          case 2:Get.offAndToNamed("/listAppointments");break;
        }
      });
    }

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Clients")
      ],
      currentIndex: _selectedItem,
      onTap: (i) => setCurrentItem(context, eventViewModel, i),
      //Show all 4 icons because more than 3 makes it invisible
      type: BottomNavigationBarType.fixed,
      //
      elevation: 0,
      unselectedItemColor: Colors.black,
      selectedItemColor: Colors.black,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      iconSize: 30,
    );
  }

}
