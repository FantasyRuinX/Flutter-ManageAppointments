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
  final TextEditingController _txtClientName = TextEditingController();
  List<Event> _clientsData = [];
  final List<String> _clientNameList = [];
  double _clientAmount = 0.0;
  String _selectedClient = "";
  int _selectedItem = 0;
  late Size _screenSize = MediaQuery.sizeOf(context);

  @override
  void initState() {
    super.initState();
    loadClients();
  }

  void loadClients() async {
    final model = Provider.of<EventViewModel>(context, listen: false);
    await model.readDB();
    _clientAmount = await model.getTotalWeekAmount();

    setState(() {
      _clientsData = model.organisedEvents;

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
          Get.offAndToNamed("/listAppointments");
          break;
      }
    });
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

  Widget analysisChart() {

    List<BarChartGroupData> weekData = [];

    for (int i = 0; i < 7; i++){
      weekData.add(BarChartGroupData(x: i, barRods: [BarChartRodData(borderRadius: BorderRadius.circular(4), width: 20, toY: (i + 1) * 2, color: Colors.blue)]));
    }

    return BarChart(BarChartData(
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            Widget text = const Text("");
            switch (value) {
              case 0:text = const Text("Mon");break;
              case 1:text = const Text("Tue");break;
              case 2:text = const Text("Wed");break;
              case 3:text = const Text("Thr");break;
              case 4:text = const Text("Fri");break;
              case 5:text = const Text("Sat");break;
              case 6:text = const Text("Sun");break;
            }
            return SideTitleWidget(meta: meta, child: text);
          },
        )),
      ),
      maxY: 20,
      barGroups: weekData,
    ));
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
                            height: _screenSize.height * 0.03,
                            child: const Text(
                                style: TextStyle(fontSize: 17),
                                "Please enter or click on client name")),
                        SizedBox(height: _screenSize.height * 0.02),
                        SizedBox(
                            width: _screenSize.width,
                            height: _screenSize.height * 0.3,
                            child: Center(child: analysisChart())),
                        SizedBox(height: _screenSize.height * 0.02),
                        SizedBox(
                            height: _screenSize.height * 0.05,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: _screenSize.width * 0.15,
                                children: [
                                  IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back))
                                  ,Text(
                                      style: const TextStyle(fontSize: 17),
                                      "Total this week : $_clientAmount"),
                                  IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward))]
                            )),
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
                        SizedBox(
                            width: _screenSize.width,
                            height: _screenSize.height * 0.25,
                            child: appointmentNameList()),
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
              )));
    });
  }
}
