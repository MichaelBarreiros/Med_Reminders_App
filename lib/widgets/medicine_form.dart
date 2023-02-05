import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/medicines_provider.dart';
import 'package:provider/provider.dart';

import '../api/notification_api.dart';
import '../models/medicine.dart';
import '../api/twilio_api.dart';

class MedicineForm extends StatefulWidget {
  final VoidCallback _goToReminderPage;
  final String id;

  MedicineForm(this._goToReminderPage, this.id);

  @override
  _MedicineFormState createState() => _MedicineFormState();
}

class _MedicineFormState extends State<MedicineForm> {
  final _form = GlobalKey<FormState>();
  Medicine _currentMed = Medicine(
    id: '',
    medicineName: '',
    medicationType: 'Tablet',
    dosage: 0,
    startDate: DateTime.now(),
    startTime: TimeOfDay.now(),
    endDate: DateTime.now(),
    repeatInterval: 'Daily',
  );

  bool isEdit = true;
  bool isLoading = false;

  void loadEditDataIfAny() {
    if (widget.id.isNotEmpty) {
      List<Medicine> medList =
          Provider.of<Medicines_Provider>(context, listen: false).medications;
      var medIdx = medList.indexWhere((element) => element.id == widget.id);
      if (medIdx != -1) {
        _currentMed = medList[medIdx];
        _selectedStartDate = _currentMed.startDate;
        _selectedEndDate = _currentMed.endDate;
        _startTime = _currentMed.startTime;
      }
    }
  }

  //form fields that need to be populated
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  TimeOfDay? _startTime;
  String _repeat = "Daily";
  String _medicationType = "Tablet";

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
        _startTime = value;
      });
    });
  }

  //Initalization of datepicker
  void _presentDatePicker(String dateType) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      if (dateType == "Start Date") {
        setState(() {
          _selectedStartDate = pickedDate;
        });
      } else if (dateType == "End Date") {
        setState(() {
          _selectedEndDate = pickedDate;
        });
      }
    });
  }

  void _sendSMS(BuildContext context) {
    TwilioApi _twilioApi = TwilioApi();
    int hour = _currentMed.startTime.hour;
    int minute = _currentMed.startTime.minute;
    String AmPm = hour < 12 ? "AM" : "PM";
    if (hour > 12) hour = hour - 12;
    Future.delayed(const Duration(seconds: 15), () {
      _twilioApi.create(
          "+14169031514",
          "ALERT: McMaster Student has not confirmed taking their medication: \"" +
              _currentMed.medicineName +
              "\" today at " +
              '$hour:$minute $AmPm.');
    });
  }

  //function to submit data
  Future<void> submitData(BuildContext ctx) async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    setState(() {
      isLoading = true;
    });

    if (_currentMed.id.isEmpty) {
      try {
        await Provider.of<Medicines_Provider>(context, listen: false)
            .addMedication(_currentMed);
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

        DateTime meetingTime = DateTime(
          _currentMed.startDate.year,
          _currentMed.startDate.month,
          _currentMed.startDate.day,
          _currentMed.startTime.hour,
          _currentMed.startTime.minute,
        );
        NotificationApi.showScheduledNotification(
          scheduledDate: meetingTime,
          payload: _currentMed.toJsonString(),
          title: 'Time to take your ${_currentMed.medicineName}',
          body: 'Click to View Reminder Details',
        );

        _sendSMS(ctx);
        // print("ALERT: McMaster Student has not confirmed taking their medication: \"" +
        //       _currentMed.medicineName +
        //       "\" today at " +
        //       _currentMed.startTime.format(context));

        widget._goToReminderPage();
      }
    } else {
      await Provider.of<Medicines_Provider>(context, listen: false)
          .updateMed(_currentMed.id, _currentMed);
      setState(() {
        isLoading = false;
      });
      widget._goToReminderPage();
    }
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
                TextFormField(
                  initialValue: _currentMed.medicineName,
                  maxLength: 40,
                  decoration: InputDecoration(
                    labelText: 'Medication Name',
                    icon: Icon(
                      Medicine.medicineNameIcon,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please provide a medicine name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _currentMed = Medicine(
                      id: _currentMed.id,
                      medicineName: value!,
                      medicationType: _currentMed.medicationType,
                      dosage: _currentMed.dosage,
                      startDate: _currentMed.startDate,
                      startTime: _currentMed.startTime,
                      endDate: _currentMed.endDate,
                      repeatInterval: _currentMed.repeatInterval,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _currentMed.dosage.toString(),
                  maxLength: 5,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Dosage (mg)',
                    icon: Icon(Medicine.dosageIcon),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please provide a dosage amount';
                    }
                    if (double.tryParse(value) == null) {
                      return "Please Enter A Valid Number";
                    }

                    if (double.parse(value) <= 0) {
                      return "Please Enter A Number Greater Than 0";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _currentMed = Medicine(
                      id: _currentMed.id,
                      medicineName: _currentMed.medicineName,
                      medicationType: _currentMed.medicationType,
                      dosage: double.parse(value!),
                      startDate: _currentMed.startDate,
                      startTime: _currentMed.startTime,
                      endDate: _currentMed.endDate,
                      repeatInterval: _currentMed.repeatInterval,
                    );
                  },
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "My medication type is of a(n)",
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                    DropdownButton<String>(
                      value: _currentMed.medicationType,
                      underline: Container(
                        height: 2,
                        color: const Color(0xFF6200EE),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _medicationType = value!;
                        });

                        _currentMed = Medicine(
                          id: _currentMed.id,
                          medicineName: _currentMed.medicineName,
                          medicationType: value!,
                          dosage: _currentMed.dosage,
                          startDate: _currentMed.startDate,
                          startTime: _currentMed.startTime,
                          endDate: _currentMed.endDate,
                          repeatInterval: _currentMed.repeatInterval,
                        );
                      },
                      items: <String>["Tablet", "Pill", "Syringe", "Other"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            child: Text(value), value: value);
                      }).toList(),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    icon: Icon(Medicine.dateIcon),
                  ),
                  controller: TextEditingController(
                      text: _selectedStartDate == null
                          ? "Choose Date"
                          : DateFormat.yMMMMd().format(_selectedStartDate!)),
                  onTap: () {
                    _presentDatePicker("Start Date");
                  },
                  validator: (value) {
                    if (value!.isEmpty || value == "Choose Date") {
                      return 'Please Select A Date';
                    }
                    return null;
                  },
                  readOnly: true,
                  onSaved: (value) {
                    _currentMed = Medicine(
                      id: _currentMed.id,
                      medicineName: _currentMed.medicineName,
                      medicationType: _currentMed.medicationType,
                      dosage: _currentMed.dosage,
                      startDate: _selectedStartDate!,
                      startTime: _currentMed.startTime,
                      endDate: _currentMed.endDate,
                      repeatInterval: _currentMed.repeatInterval,
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Start Time',
                    icon: Icon(Medicine.timeIcon),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6200EE)),
                    ),
                  ),
                  controller: TextEditingController(
                      text: _startTime == null
                          ? "Choose Time"
                          : _startTime!.format(context)),
                  onTap: _chooseTime,
                  readOnly: true,
                  validator: (value) {
                    if (value!.isEmpty || value == "Choose Time") {
                      return 'Please Select A Time';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _currentMed = Medicine(
                      id: _currentMed.id,
                      medicineName: _currentMed.medicineName,
                      medicationType: _currentMed.medicationType,
                      dosage: _currentMed.dosage,
                      startDate: _currentMed.startDate,
                      startTime: _startTime!,
                      endDate: _currentMed.endDate,
                      repeatInterval: _currentMed.repeatInterval,
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6200EE)),
                      ),
                      labelText: 'End Date',
                      icon: Icon(Medicine.dateIcon)),
                  controller: TextEditingController(
                      text: _selectedEndDate == null
                          ? "Choose Date"
                          : DateFormat.yMMMMd().format(_selectedEndDate!)),
                  onTap: () {
                    _presentDatePicker("End Date");
                  },
                  readOnly: true,
                  validator: (value) {
                    if (value!.isEmpty || value == "Choose Date") {
                      return 'Please Select A Date';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _currentMed = Medicine(
                      id: _currentMed.id,
                      medicineName: _currentMed.medicineName,
                      medicationType: _currentMed.medicationType,
                      dosage: _currentMed.dosage,
                      startDate: _currentMed.startDate,
                      startTime: _currentMed.startTime,
                      endDate: _selectedEndDate!,
                      repeatInterval: _currentMed.repeatInterval,
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
                      value: _currentMed.repeatInterval,
                      underline: Container(
                        height: 2,
                        color: const Color(0xFF6200EE),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _repeat = value!;
                        });

                        _currentMed = Medicine(
                          id: _currentMed.id,
                          medicineName: _currentMed.medicineName,
                          medicationType: _currentMed.medicationType,
                          dosage: _currentMed.dosage,
                          startDate: _currentMed.startDate,
                          startTime: _currentMed.startTime,
                          endDate: _currentMed.endDate,
                          repeatInterval: value!,
                        );
                      },
                      items: <String>["Daily", "Weekly", "Monthly"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            child: Text(value), value: value);
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 35,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF6200EE)),
                    onPressed: () {
                      submitData(context);
                    },
                    child: const Text(
                      'Schedule',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
