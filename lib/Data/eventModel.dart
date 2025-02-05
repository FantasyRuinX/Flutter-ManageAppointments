import 'package:flutter/material.dart';

class Events{

  final DateTime date;
  final List<String> events;

  Events({
    required this.date,
    required this.events
  });

  @override
  String toString() {
    return "$date : ${events.length} events";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Events && other.date == date && other.events == events;
  }

  @override
  int get hashCode => date.hashCode;

}