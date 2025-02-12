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
    ));
  }
}
