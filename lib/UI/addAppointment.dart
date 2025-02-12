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
          children: <Widget>[
            TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter client name")),
            TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "Enter time")),
            TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "Enter location")),
            TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "Enter payment")),
            TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter description"))
          ]),
    );
  }
}
