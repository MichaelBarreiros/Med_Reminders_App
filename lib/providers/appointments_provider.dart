import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import '../models/appointment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Appointments_Provider with ChangeNotifier {
  List<Appointment> _appointments = [];
  String? _authToken;
  String? _userId;

  set authToken(String value) {
    _authToken = value;
  }

  set userId(String value) {
    _userId = value;
  }

  List<Appointment> get appointments {
    return [..._appointments];
  }

  Future<void> fetchData() async {
    Uri url = Uri.parse(
        'https://trackrx-ec1c1-default-rtdb.firebaseio.com/appointments.json?auth=$_authToken&orderBy="userId"&equalTo="$_userId"');
    try {
      final response = await http.get(url);
      if (json.decode(response.body) == null) {
        return;
      }
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) {
        return;
      }
      final List<Appointment> appointmentData = [];

      data.forEach((id, value) {
        appointmentData.add(Appointment(
          id: id,
          appointmentName: value['appointment_name'],
          date: DateTime.parse(value['date']),
          time: TimeOfDay(
            hour: int.parse(value['time'].split(":")[0]),
            minute: int.parse(value['time'].split(":")[1]),
          ),
          repeatInterval: value['repeat_interval'],
        ));
      });
      _appointments = appointmentData;
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    Uri url = Uri.parse(
        'https://trackrx-ec1c1-default-rtdb.firebaseio.com/appointments.json?auth=$_authToken');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'appointment_name': appointment.appointmentName,
            'date': appointment.date.toString(),
            'time': appointment.time.hour.toString() +
                ":" +
                appointment.time.minute.toString(),
            'repeat_interval': appointment.repeatInterval,
            'userId': _userId
          },
        ),
      );

      Appointment newAppointment = Appointment(
          id: json.decode(response.body)['name'],
          appointmentName: appointment.appointmentName,
          date: appointment.date,
          time: appointment.time,
          repeatInterval: appointment.repeatInterval);
      _appointments.add(newAppointment);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> removeAppointment(String id) async {
    Uri url = Uri.parse(
        'https://trackrx-ec1c1-default-rtdb.firebaseio.com/appointments/$id.json?auth=$_authToken');

    final existingIndex =
        _appointments.indexWhere((element) => element.id == id);
    Appointment? existingAppoint = _appointments[existingIndex];
    _appointments.removeAt(existingIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _appointments.insert(existingIndex, existingAppoint);
      notifyListeners();
      throw HttpException("Could not delete reminder.");
    }
    existingAppoint = null;
  }

  Future<void> updateAppointment(String id, Appointment newAppointment) async {
    int idx = _appointments.indexWhere((element) => element.id == id);

    if (idx != -1) {
      Uri url = Uri.parse(
          'https://trackrx-ec1c1-default-rtdb.firebaseio.com/appointments/$id.json?auth=$_authToken');
      await http.patch(
        url,
        body: json.encode(
          {
            'appointment_name': newAppointment.appointmentName,
            'date': newAppointment.date.toString(),
            'time': newAppointment.time.hour.toString() +
                ":" +
                newAppointment.time.minute.toString(),
            'repeat_interval': newAppointment.repeatInterval,
          },
        ),
      );
      _appointments[idx] = newAppointment;
      notifyListeners();
    }
  }
}
