import 'package:flutter/material.dart';

class RemoveAppointment extends StatelessWidget {
  final String title;

  const RemoveAppointment({super.key, required this.title});

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
