import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Medicine {
  static IconData medicineNameIcon = Icons.medical_services_outlined;
  static IconData medicationTypeIcon = Icons.add_circle;
  static IconData dosageIcon = Icons.fitness_center;
  static IconData dateIcon = Icons.date_range_outlined;
  static IconData timeIcon = Icons.access_time_outlined;
  static IconData repeatIntervalIcon = Icons.access_alarm;
  final String id;
  final String medicineName;
  final String medicationType;
  final double dosage;
  final DateTime startDate;
  final TimeOfDay startTime;
  final DateTime endDate;
  final String repeatInterval;

  Medicine({
    required this.id,
    required this.medicineName,
    required this.medicationType,
    required this.dosage,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.repeatInterval,
  });

  factory Medicine.fromJsonString(String str) =>
      Medicine._fromJson(jsonDecode(str));

  String toJsonString() {
    String json = jsonEncode(_toJson());
    print("toJson: " + json);
    return json;
  }

  factory Medicine._fromJson(Map<String, dynamic> json) {
    print("from json:");
    print(json);
    List<String> startTimeString = json['startTime'].split(':');
    print(startTimeString);

    int hour = int.parse(startTimeString[0]);
    int minute = int.parse(startTimeString[0]);
    return Medicine(
      id: json['id'],
      medicineName: json['medicineName'],
      medicationType: json['medicationType'],
      dosage: json['dosage'],
      startDate: DateTime.parse(json['startDate']),
      startTime: TimeOfDay(hour: hour, minute: minute),
      endDate: DateTime.parse(json['endDate']),
      repeatInterval: json['repeatInterval'],
    );
  }

  Map<String, dynamic> _toJson() => {
        'id': id,
        'medicineName': medicineName,
        'medicationType': medicationType,
        'dosage': dosage,
        'startDate': startDate.toIso8601String(),
        'startTime': '${startTime.hour}:${startTime.minute}',
        'endDate': endDate.toIso8601String(),
        'repeatInterval': repeatInterval,
      };
}
