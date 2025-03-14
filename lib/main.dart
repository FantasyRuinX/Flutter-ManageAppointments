import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:Flutter_ManageAppointments/Data/eventViewModel.dart';

import 'UI/home.dart';
import 'UI/addAppointment.dart';
import 'UI/listAppointment.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => EventViewModel())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white38),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      getPages: [
        GetPage(
            name: '/home',
            page: () => const MyHomePage(title: 'Appointments'),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut),
        GetPage(
            name: '/addAppointments',
            page: () => const AddAppointment(title: 'Manage appointments'),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut),
        GetPage(
            name: '/listAppointments',
            page: () => const ListAppointment(title: 'List appointments'),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut),
      ],
    );
  }
}
