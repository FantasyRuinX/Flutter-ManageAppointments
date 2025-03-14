import 'package:flutter_background_service/flutter_background_service.dart';

Future<void> initiateBackgroundService() async {
  final service = FlutterBackgroundService();
  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart, isForegroundMode: true, autoStart: true));
}

void onStart(ServiceInstance service) {}
