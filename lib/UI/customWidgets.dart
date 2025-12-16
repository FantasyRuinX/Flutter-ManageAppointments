
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:Flutter_ManageAppointments/Data/eventViewModel.dart';
import 'package:get/get.dart';
import '../Data/eventModel.dart';


Widget bottomBarOptions(VoidCallback setButtonActions,int _selectedItem, BuildContext context){

  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "Clients")
    ],
    currentIndex: _selectedItem,
    onTap: (i) => setButtonActions(),//setCurrentItem(context, eventViewModel, i),
    //Show all 4 icons because more than 3 makes it invisible
    type: BottomNavigationBarType.fixed,
    //
    elevation: 0,
    unselectedItemColor: Colors.black,
    selectedItemColor: Colors.black,
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    iconSize: 30,
  );
}