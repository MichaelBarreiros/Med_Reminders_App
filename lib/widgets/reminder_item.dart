import 'package:flutter/material.dart';
import 'package:med_reminders_app/screens/reminder_detail_screen.dart';

import '../models/medicine.dart';

class ReminderItem extends StatelessWidget {
  Function removeReminder;
  final Medicine medicine;

  ReminderItem(this.medicine, this.removeReminder, {Key? key})
      : super(key: key);

  _selectReminder(BuildContext context) {
    Navigator.of(context).pushNamed(ReminderDetailScreen.routeName,
        arguments: {'removeReminder': removeReminder, 'medicine': medicine});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectReminder(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Medicine.medicineNameIcon),
                      SizedBox(width: 6),
                      Text('${medicine.medicineName}'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Medicine.timeIcon),
                      SizedBox(width: 6),
                      Text('${medicine.startTime.format(context)}'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Medicine.repeatIntervalIcon),
                      SizedBox(width: 6),
                      Text('${medicine.repeatInterval}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
