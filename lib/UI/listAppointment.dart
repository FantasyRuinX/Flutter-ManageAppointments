import 'package:flutter/material.dart';

class ListAppointment extends StatelessWidget {
  final String title;

  const ListAppointment({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      centerTitle: true,
      title: Text(title),
    ));
  }
}
