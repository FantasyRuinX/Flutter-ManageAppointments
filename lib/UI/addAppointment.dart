import 'package:flutter/material.dart';

class AddAppointment extends StatelessWidget {
  final String title;

  const AddAppointment({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(title),
      ),
      body: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: <Widget>[
            SizedBox(height: 5),
            Text("Please enter all of the following information"),
            SizedBox(
                height: 30, width : 300,
                child : TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0,),
                    border: OutlineInputBorder(),
                    hintText: "Enter client name"))),
            TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "Enter time")),
            SizedBox(
                height: 30, width : 300,
                child : TextField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0,),
                        border: OutlineInputBorder(),
                        hintText: "Enter location"))),
            SizedBox(
                height: 30, width : 300,
                child : TextField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0,),
                        border: OutlineInputBorder(),
                        hintText: "Enter payment amount"))),
            TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter description"))
          ]),
    );
  }
}
