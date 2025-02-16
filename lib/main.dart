import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Flutter_ManageAppointments/Data/eventViewModel.dart';

import 'UI/home.dart';
import 'UI/addAppointment.dart';
import 'UI/listAppointment.dart';
import 'UI/changeAppointment.dart';
import 'UI/removeAppointment.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => EventViewModel())],
      child: const MyApp(),
    ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/home",
      routes: {
        "/home" : (context) => const MyHomePage(title: 'Appointments'),
        "/addAppointments" : (context) => const AddAppointment(title: 'Add appointments'),
        "/listAppointments" : (context) => const ListAppointment(title: 'List appointments'),
        "/changeAppointments" : (context) => const ChangeAppointment(title: 'Change appointments'),
        "/removeAppointments" : (context) => const RemoveAppointment(title: 'Remove appointments'),
      },

    );
  }
}
