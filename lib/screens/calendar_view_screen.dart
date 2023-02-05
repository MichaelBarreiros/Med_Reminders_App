import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/appointments_provider.dart';
import '../providers/medicines_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../models/medicine.dart';
import '../models/appointment.dart' as ap;

class CalendarViewScreen extends StatefulWidget {
  static const String routeName = '/calendarViewScreen';

  // CalendarViewScreen();

  @override
  State<CalendarViewScreen> createState() => _CalendarViewScreenState();
}

class _CalendarViewScreenState extends State<CalendarViewScreen> {
  @override
  Widget build(BuildContext context) {
    final medData = Provider.of<Medicines_Provider>(context);
    List<Medicine> medicineReminders = medData.medications;
    final appointmentData = Provider.of<Appointments_Provider>(context);
    List<ap.Appointment> appointmentReminders = appointmentData.appointments;

    return SfCalendar(
      view: CalendarView.schedule,
      dataSource: MeetingDataSource(
          getAppointments(medicineReminders, appointmentReminders)),
      scheduleViewSettings: ScheduleViewSettings(
        monthHeaderSettings:
            MonthHeaderSettings(backgroundColor: Color(0xFF6200EE)),
      ),
    );
  }
}

List<Appointment> getAppointments(
    List<Medicine> medReminders, List<ap.Appointment> appReminders) {
  List<Appointment> meetings = <Appointment>[];
  List<Color> colorSelect = [
    Colors.deepPurple.shade300,
    Colors.deepPurpleAccent,
    Colors.purple,
    Colors.deepPurple.shade900,
    Colors.deepPurple,
  ];

  int colorIndex = 0;

  for (int i = 0; i < medReminders.length; i++) {
    String repeating;

    int daysDiff =
        (medReminders[i].endDate.difference(medReminders[i].startDate).inHours /
                24)
            .round();

    if (medReminders[i].repeatInterval == 'Daily') {
      repeating = 'FREQ=DAILY;COUNT=${daysDiff + 1}';
    } else if (medReminders[i].repeatInterval == 'Weekly') {
      String dayFormat =
          DateFormat('EEEE').format(medReminders[i].startDate).toUpperCase();
      repeating =
          'FREQ=WEEKLY;BYDAY=${dayFormat.substring(0, 2)};COUNT=${(daysDiff / 7).round() + 1}';
    } else {
      repeating =
          'FREQ=MONTHLY;BYMONTHDAY=${medReminders[i].startDate.day};COUNT=${(daysDiff / 30).round()}';
    }

    meetings.add(Appointment(
      startTime: DateTime(
          medReminders[i].startDate.year,
          medReminders[i].startDate.month,
          medReminders[i].startDate.day,
          medReminders[i].startTime.hour,
          medReminders[i].startTime.minute),
      endTime: DateTime(
          medReminders[i].startDate.year,
          medReminders[i].startDate.month,
          medReminders[i].startDate.day,
          medReminders[i].startTime.hour,
          medReminders[i].startTime.minute + 5),
      subject:
          '${medReminders[i].medicineName} Dosage: ${medReminders[i].dosage} mg',
      color: colorSelect[colorIndex++ % colorSelect.length],
      recurrenceRule: repeating,
    ));
  }

  for (int i = 0; i < appReminders.length; i++) {
    meetings.add(Appointment(
      startTime: DateTime(
          appReminders[i].date.year,
          appReminders[i].date.month,
          appReminders[i].date.day,
          appReminders[i].time.hour,
          appReminders[i].time.minute),
      endTime: DateTime(
          appReminders[i].date.year,
          appReminders[i].date.month,
          appReminders[i].date.day,
          appReminders[i].time.hour,
          appReminders[i].time.minute + 30),
      subject: appReminders[i].appointmentName,
      color: colorSelect[colorIndex++ % colorSelect.length],
    ));
  }

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
