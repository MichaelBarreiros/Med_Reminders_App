import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/appointments_provider.dart';
import 'package:provider/provider.dart';

import '../models/appointment.dart';
import '../api/notification_api.dart';
import '../api/twilio_api.dart';

class AppointmentForm extends StatefulWidget {
  final VoidCallback _goToReminderPage;
  final String id;

  AppointmentForm(this._goToReminderPage, this.id);
  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final _form = GlobalKey<FormState>();

  Appointment _currentAppointment = Appointment(
    id: '',
    appointmentName: '',
    date: DateTime.now(),
    time: TimeOfDay.now(),
    repeatInterval: "Monthly",
  );

  bool isEdit = true;
  bool isLoading = false;

  void loadEditDataIfAny() {
    if (widget.id.isNotEmpty) {
      List<Appointment> appointmentList =
          Provider.of<Appointments_Provider>(context, listen: false)
              .appointments;
      var idx =
          appointmentList.indexWhere((element) => element.id == widget.id);
      if (idx != -1) {
        _currentAppointment = appointmentList[idx];
        _selectedDate = _currentAppointment.date;
        _selectedTime = _currentAppointment.time;
      }
    }
  }

  String _appointmentName = '';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _repeat = "Monthly";

  //initialization of timepicker
  void _chooseTime() {
    showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedTime = value;
      });
    });
  }

  //Initalization of datepicker
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _sendSMS() {
    TwilioApi _twilioApi = TwilioApi();
    Future.delayed(const Duration(minutes: 2), () {
      _twilioApi.create(
          "+16477123583",
          "McMaster Student has missed their appointment - " +
              _currentAppointment.appointmentName +
              " at time " +
              _currentAppointment.time.toString() +
              " today");
    });
  }

  //function to submit data
  Future<void> submitData() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    setState(() {
      isLoading = true;
    });

    if (_currentAppointment.id.isEmpty) {
      try {
        await Provider.of<Appointments_Provider>(context, listen: false)
            .addAppointment(_currentAppointment);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An Error Occurred"),
            content: Text("Something went wrong"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Okay"))
            ],
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
        widget._goToReminderPage();
      }
    } else {
      await Provider.of<Appointments_Provider>(context, listen: false)
          .updateAppointment(_currentAppointment.id, _currentAppointment);
      setState(() {
        isLoading = false;
      });
      widget._goToReminderPage();
    }

    // DateTime meetingTime = DateTime(
    //   _selectedDate!.year,
    //   _selectedDate!.month,
    //   _selectedDate!.day,
    //   _selectedTime!.hour,
    //   _selectedTime!.minute,
    // );

    // NotificationApi.showScheduledNotification(
    //   scheduledDate: meetingTime,
    //   payload: appointment.toJsonString(),
    //   title: 'Time to go to you $_appointmentName appointment',
    //   body: 'Click to View Reminder Details',
    // );

    // widget._addReminder(appointment, false);
  }

  @override
  Widget build(BuildContext context) {
    if (isEdit) {
      loadEditDataIfAny();
      isEdit = false;
    }
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Form(
            key: _form,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  initialValue: _currentAppointment.appointmentName,
                  maxLength: 40,
                  decoration: InputDecoration(
                    labelText: 'Appointment Name',
                    icon: Icon(
                      Appointment.appointment,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please provide an appointment title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _currentAppointment = Appointment(
                      id: _currentAppointment.id,
                      appointmentName: value!,
                      date: _currentAppointment.date,
                      time: _currentAppointment.time,
                      repeatInterval: _currentAppointment.repeatInterval,
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Appointment Date',
                    icon: Icon(Appointment.dateIcon),
                  ),
                  controller: TextEditingController(
                      text: _selectedDate == null
                          ? "Choose Date"
                          : DateFormat.yMMMMd().format(_selectedDate!)),
                  onTap: () {
                    _presentDatePicker();
                  },
                  readOnly: true,
                  validator: (value) {
                    if (value!.isEmpty || value == "Choose Date") {
                      return 'Please Select A Date';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _currentAppointment = Appointment(
                      id: _currentAppointment.id,
                      appointmentName: _currentAppointment.appointmentName,
                      date: _selectedDate!,
                      time: _currentAppointment.time,
                      repeatInterval: _currentAppointment.repeatInterval,
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Appointment Time',
                    icon: Icon(Appointment.timeIcon),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6200EE)),
                    ),
                  ),
                  controller: TextEditingController(
                      text: _selectedTime == null
                          ? "Choose Time"
                          : _selectedTime!.format(context)),
                  onTap: _chooseTime,
                  readOnly: true,
                  validator: (value) {
                    if (value!.isEmpty || value == "Choose Time") {
                      return 'Please Select A Time';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _currentAppointment = Appointment(
                      id: _currentAppointment.id,
                      appointmentName: _currentAppointment.appointmentName,
                      date: _currentAppointment.date,
                      time: _selectedTime!,
                      repeatInterval: _currentAppointment.repeatInterval,
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "This reminder should repeat",
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                    DropdownButton<String>(
                      value: _currentAppointment.repeatInterval,
                      underline: Container(
                        height: 2,
                        color: const Color(0xFF6200EE),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _repeat = value!;
                        });
                        _currentAppointment = Appointment(
                          id: _currentAppointment.id,
                          appointmentName: _currentAppointment.appointmentName,
                          date: _currentAppointment.date,
                          time: _currentAppointment.time,
                          repeatInterval: value!,
                        );
                      },
                      items: <String>[
                        "Monthly",
                        "Every 3 Months",
                        "Every 6 Months",
                        "Yearly"
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            child: Text(value), value: value);
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 35,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF6200EE)),
                    onPressed: () {
                      // Respond to button press
                      submitData();
                    },
                    child: const Text(
                      'Schedule',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
