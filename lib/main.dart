import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:Flutter_ManageAppointments/Data/eventViewModel.dart';
import 'Data/backgroundService.dart';
import 'UI/analysisAppointment.dart';
import 'UI/home.dart';
import 'UI/addAppointment.dart';
import 'UI/listAppointment.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.notification.isDenied.then((value) => Permission.notification.request());
  await initiateBackgroundService();

  runApp(DevicePreview(
      builder: (context) => MultiProvider(
            providers: [ChangeNotifierProvider(create: (_) => EventViewModel())],
            child: const MyApp(),
          )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

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
            preventDuplicates: true,
            transition: Transition.zoom,
            transitionDuration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut),
        GetPage(
            name: '/addAppointments',
            page: () => const AddAppointment(title: 'Manage appointments'),
            preventDuplicates: true,
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut),
        GetPage(
            name: '/listAppointments',
            page: () => const ListAppointment(title: 'List appointments'),
            preventDuplicates: true,
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut),
        GetPage(
            name: '/analysisAppointments',
            page: () => const AnalysisAppointment(title: 'Analysis appointments'),
            preventDuplicates: true,
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut),
      ],
    );
  }
}
