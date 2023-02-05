// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:med_reminders_app/models/appointment.dart';
import 'package:med_reminders_app/models/medicine.dart';
import 'package:med_reminders_app/providers/appointments_provider.dart';
import 'package:med_reminders_app/providers/medicines_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/appointment_form.dart';
import '../widgets/medicine_form.dart';

class AddRemindersScreen extends StatefulWidget {
  static const String routeName = '/addRemindersScreen';

  final VoidCallback _goToReminderPage;
  String reminderId;

  AddRemindersScreen(this._goToReminderPage, this.reminderId);

  @override
  State<AddRemindersScreen> createState() => _AddRemindersScreenState();
}

class _AddRemindersScreenState extends State<AddRemindersScreen> {
  String _reminderType = "Medication";

  @override
  Widget build(BuildContext context) {
    final medData = Provider.of<Medicines_Provider>(context, listen: false);
    List<Medicine> medReminders = medData.medications;

    final appointmentData =
        Provider.of<Appointments_Provider>(context, listen: false);
    List<Appointment> appointmentReminders = appointmentData.appointments;
    if (widget.reminderId.isNotEmpty) {
      if (appointmentReminders
              .indexWhere((element) => element.id == widget.reminderId) !=
          -1) {
        setState(() {
          _reminderType = "Medical Appointment";
        });
      }
    }
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Reminder Type: ",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  ),
                  DropdownButton<String>(
                    value: _reminderType,
                    underline: Container(
                      height: 2,
                      color: const Color(0xFF6200EE),
                    ),
                    onChanged: (String? value) {
                      widget.reminderId = "";
                      setState(() {
                        _reminderType = value!;
                      });
                    },
                    items: <String>["Medication", "Medical Appointment"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          child: Text(value), value: value);
                    }).toList(),
                  ),
                ],
              ),
              _reminderType == "Medication"
                  ? MedicineForm(widget._goToReminderPage, widget.reminderId)
                  : AppointmentForm(
                      widget._goToReminderPage, widget.reminderId),
            ],
          ),
        ),
      ),
    );
  }
}
