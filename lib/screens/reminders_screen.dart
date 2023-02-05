import 'package:flutter/material.dart';
import '../providers/appointments_provider.dart';
import '../providers/medicines_provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:provider/provider.dart';

import '../widgets/appointment_card.dart';
import '../models/appointment.dart';
import '../widgets/medicine_card.dart';
import '../models/medicine.dart';
import 'globals.dart' as globals;

class RemindersScreen extends StatefulWidget {
  final Function goToEditPage;
  RemindersScreen(this.goToEditPage);
  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  int reminderIndex = 0;
  bool isInit = true;
  bool isLoadingMed = false;
  bool isLoadingAppoint = false;
  List<Medicine> medicationReminders = [];
  List<Appointment> appointmentReminders = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoadingMed = true;
        isLoadingAppoint = true;
      });

      Provider.of<Medicines_Provider>(context).fetchData().then((_) {
        setState(() {
          isLoadingMed = false;
          globals.globalLoadMed = false;
        });
      });
      Provider.of<Appointments_Provider>(context).fetchData().then((_) {
        setState(() {
          isLoadingAppoint = false;
          globals.globalLoadAppoint = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  Widget reminderList() {
    if (reminderIndex == 0) {
      return medicationReminders.isEmpty
          ? Center(
              child: Text(
                'You have no medicine reminders! - Add some',
                style: TextStyle(
                  color: Color(0xFF6200EE),
                ),
              ),
            )
          : SizedBox(
              width: double.infinity,
              height: 400,
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                itemBuilder: (ctx, i) {
                  return MedicineCard(
                      medicationReminders[i], widget.goToEditPage);
                },
                itemCount: medicationReminders.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
              ));
    } else if (reminderIndex == 1) {
      return appointmentReminders.isEmpty
          ? Center(
              child: Text(
                'You have no appointment reminders! - Add some',
                style: TextStyle(
                  color: Color(0xFF6200EE),
                ),
              ),
            )
          : SizedBox(
              width: double.infinity,
              height: 400,
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                itemBuilder: (ctx, i) {
                  return AppointmentCard(
                      appointmentReminders[i], widget.goToEditPage);
                },
                itemCount: appointmentReminders.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
              ));
    } else {
      return const Text('Unknown Index Receieved for listType');
    }
  }

  void updateReminderView(int? index) {
    setState(() {
      reminderIndex = index ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final medData = Provider.of<Medicines_Provider>(context);
    medicationReminders = medData.medications;
    final appointmentData = Provider.of<Appointments_Provider>(context);
    appointmentReminders = appointmentData.appointments;

    return (isLoadingMed || isLoadingAppoint) &&
            (globals.globalLoadAppoint || globals.globalLoadMed)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                ToggleSwitch(
                  activeBgColor: [Color(0xFF6200EE)],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.grey[900],
                  initialLabelIndex: reminderIndex,
                  minWidth: 180.0,
                  totalSwitches: 2,
                  fontSize: 18,
                  labels: ['Medication', 'Appointment'],
                  onToggle: (index) {
                    //updateReminderView(index);
                    updateReminderView(index);
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                SizedBox(
                  height: 525,
                  child: reminderList(),
                ),
              ],
            ),
          );
  }
}
