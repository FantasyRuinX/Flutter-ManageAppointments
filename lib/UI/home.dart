import 'package:flutter/material.dart';
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


  @override
  void initState() {
    super.initState();
    _focusedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            TableCalendar(
              focusedDay: _focusedDate,
              firstDay: DateTime.utc(2001,1,1),
              lastDay: DateTime.utc(2050,1,1),

              //Show selected date
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),

              onDaySelected: (selectedDay,focusedDay){
                if (!isSameDay(_selectedDate, selectedDay)) {
                  setState(() {
                    _selectedDate = selectedDay;
                    _focusedDate = focusedDay;
                  });
                }},
              //----------------

              eventLoader: (day) => [1,2],

            )

          ],),),
    );
  }
}
