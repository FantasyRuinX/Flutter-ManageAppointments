import 'dart:async';
import 'dart:ui';
import 'package:Flutter_ManageAppointments/Data/eventModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../Business/sqlDatabase.dart';

List<Event> appointments = [];
Timer? checkTime;
final ClientDatabase clientDatabase = ClientDatabase.instance;
final FlutterLocalNotificationsPlugin notificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initiateBackgroundService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      initialNotificationTitle: 'Manage Appointments',
      initialNotificationContent: 'Checking appointments...',
      foregroundServiceNotificationId: 888,
    ),
  );

}

void showNotification(String title, String content) {

  var androidDetails = AndroidNotificationDetails(
    '0000',
    'Notify',
    channelDescription: 'Notify user of appointment',
    icon: "@mipmap/ic_launcher",
    autoCancel: true,
    playSound: true,
    color: Colors.cyan[200],
  );

  var notificationDetails = NotificationDetails(
    android: androidDetails,
  );

  notificationsPlugin.show(
      0000,
      title,
      content,
      notificationDetails);
}

void timerNotification(ServiceInstance service){
  checkTime = Timer.periodic(const Duration(seconds: 5), (timer) async {

    appointments = await clientDatabase.readData();

    if (service is AndroidServiceInstance) {
      DateTime currentTime = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, DateTime.now().hour, DateTime.now().minute);

      for (Event item in appointments) {
        DateTime itemTime = DateTime.parse("${item.date} ${item.start}:00");
        if (itemTime == currentTime) {

          showNotification("Appointment : ${item.name}", item.info);
          checkTime?.cancel();

          Future.delayed(const Duration(minutes: 1), (){
            timerNotification(service);
          });
        }
      }
    }

    service.invoke("update");
  });
}

@pragma("vm:entry-point")
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  service.on("stopService").listen((event) {
    service.stopSelf();
  });

  timerNotification(service);
}
