import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/medicine.dart';

//   final String medicineName;
//   final String medicationType;
//   final double dosage;
//   final DateTime startDate;
//   final TimeOfDay startTime;
//   final DateTime endDate;
//   final String repeatInterval;

class ReminderDetailScreen extends StatelessWidget {
  static String googleAPIKey = 'AIzaSyAKHI6sPnnfsOFQXUY8oZbXdxkgWhDe1z4';
  static String routeName = '/reminder_detail_screen';

  late Function removeReminder;
  late Medicine medicine;

  void onPressDeleteButton(BuildContext context) {
    removeReminder(medicine);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Object> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    removeReminder = arguments['removeReminder'] as Function;
    medicine = arguments['medicine'] as Medicine;

    return Scaffold(
      appBar: AppBar(title: Text(medicine.medicineName)),
      body: Card(
        child: Column(
          children: [
            Text('Medicine Type: ${medicine.medicationType}'),
            Text('Medicine Dosage: ${medicine.dosage}mg'),
            Text(
                'Medicine Start Date: ${DateFormat.yMMMd().format(medicine.startDate)}'),
            Text(
                'Medicine End Date: ${DateFormat.yMMMd().format(medicine.endDate)}'),
            Text('Medicine Time: ${medicine.startTime.format(context)}'),
            Text('Medicine Repeats: ${medicine.repeatInterval}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: () => onPressDeleteButton(context),
      ),
    );
  }
}
