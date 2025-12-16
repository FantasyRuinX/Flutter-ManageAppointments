
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:Flutter_ManageAppointments/Data/eventViewModel.dart';
import 'package:get/get.dart';
import '../Data/eventModel.dart';

Widget customDrawer(){
  return Drawer(
      child : ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
              decoration: BoxDecoration(color: Colors.white38),
              child: Text('Menu', style: TextStyle(color: Colors.black))),
          ListTile(
            leading: Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {if (Get.currentRoute != "/home"){Get.offAndToNamed("/home");}},
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: const Text('Add'),
            onTap: () {if (Get.currentRoute != "/addAppointments"){Get.offAndToNamed("/addAppointments",arguments: <String, dynamic>{"updateEvent": null});}},
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: const Text('Clients'),
            onTap: () {if (Get.currentRoute != "/listAppointments"){Get.offAndToNamed("/listAppointments");}},
          ),
          ListTile(
            leading: Icon(Icons.stacked_bar_chart),
            title: const Text('Statistics'),
            onTap: () {if (Get.currentRoute != "/analysisAppointments"){Get.offAndToNamed("/analysisAppointments");}},
          ),
        ],
      )
  );
}