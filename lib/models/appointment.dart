import 'package:flutter/material.dart';
import 'dart:convert';

class Appointment {
  final String id;
  final String appointmentName;
  final TimeOfDay time;
  final DateTime date;
  final String repeatInterval;

  static IconData dateIcon = Icons.date_range_outlined;
  static IconData timeIcon = Icons.access_time_outlined;
  static IconData appointment = Icons.medical_services_outlined;

  Appointment({
    required this.id,
    required this.appointmentName,
    required this.date,
    required this.time,
    required this.repeatInterval,
  });

  factory Appointment.fromJsonString(String str) =>
      Appointment._fromJson(jsonDecode(str));

  String toJsonString() => jsonEncode(_toJson());

  factory Appointment._fromJson(Map<String, dynamic> json) {
    List<String> timeString = json['time'].split(':');

    int hour = int.parse(timeString[0]);
    int minute = int.parse(timeString[0]);
    return Appointment(
      id: json['id'],
      appointmentName: json['medicineName'],
      date: DateTime.parse(json['date']),
      time: TimeOfDay(hour: hour, minute: minute),
      repeatInterval: json['repeatInterval'],
    );
  }

  Map<String, dynamic> _toJson() => {
        'medicineName': appointmentName,
        'date': date.toIso8601String(),
        'time': '${time.hour}:${time.minute}',
        'repeatInterval': repeatInterval,
      };
}
