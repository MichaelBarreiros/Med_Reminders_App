import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import '../models/medicine.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Medicines_Provider with ChangeNotifier {
  List<Medicine> _medications = [];
  String? _authToken;
  String? _userId;

  set authToken(String value) {
    _authToken = value;
  }

  set userId(String value) {
    _userId = value;
  }

  List<Medicine> get medications {
    return [..._medications];
  }

  Future<void> fetchData() async {
    Uri url = Uri.parse(
        'https://trackrx-ec1c1-default-rtdb.firebaseio.com/medications.json?auth=$_authToken&orderBy="userId"&equalTo="$_userId"');
    try {
      final response = await http.get(url);
      if (json.decode(response.body) == null) {
        return;
      }
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) {
        return;
      }
      final List<Medicine> medData = [];

      data.forEach((medId, value) {
        medData.add(Medicine(
          id: medId,
          medicineName: value['med_name'],
          medicationType: value['med_type'],
          dosage: double.parse(value['dosage'].toString()),
          startDate: DateTime.parse(value['start_date']),
          startTime: TimeOfDay(
            hour: int.parse(value['start_time'].split(":")[0]),
            minute: int.parse(value['start_time'].split(":")[1]),
          ),
          endDate: DateTime.parse(value['end_date']),
          repeatInterval: value['repeat_interval'],
        ));
      });
      _medications = medData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addMedication(Medicine med) async {
    Uri url = Uri.parse(
        'https://trackrx-ec1c1-default-rtdb.firebaseio.com/medications.json?auth=$_authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'med_name': med.medicineName,
          'med_type': med.medicationType,
          'dosage': med.dosage,
          'start_date': med.startDate.toString(),
          'start_time': med.startTime.hour.toString() +
              ":" +
              med.startTime.minute.toString(),
          'end_date': med.endDate.toString(),
          'repeat_interval': med.repeatInterval,
          'userId': _userId,
        }),
      );

      Medicine newMed = Medicine(
          id: json.decode(response.body)['name'],
          medicineName: med.medicineName,
          medicationType: med.medicationType,
          dosage: med.dosage,
          startDate: med.startDate,
          startTime: med.startTime,
          endDate: med.endDate,
          repeatInterval: med.repeatInterval);
      _medications.add(newMed);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> removeMedication(String id) async {
    Uri url = Uri.parse(
        'https://trackrx-ec1c1-default-rtdb.firebaseio.com/medications/$id.json?auth=$_authToken');

    final existingMedIndex =
        _medications.indexWhere((element) => element.id == id);
    Medicine? existingMed = _medications[existingMedIndex];
    _medications.removeAt(existingMedIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _medications.insert(existingMedIndex, existingMed);
      notifyListeners();
      throw HttpException("Could not delete reminder.");
    }
    existingMed = null;
  }

  Future<void> updateMed(String id, Medicine newMed) async {
    int idx = _medications.indexWhere((element) => element.id == id);

    if (idx != -1) {
      Uri url = Uri.parse(
          'https://trackrx-ec1c1-default-rtdb.firebaseio.com/medications/$id.json?auth=$_authToken');
      await http.patch(url,
          body: json.encode(
            {
              'med_name': newMed.medicineName,
              'med_type': newMed.medicationType,
              'dosage': newMed.dosage.toString(),
              'start_date': newMed.startDate.toString(),
              'start_time': newMed.startTime.hour.toString() +
                  ":" +
                  newMed.startTime.minute.toString(),
              'end_date': newMed.endDate.toString(),
              'repeat_interval': newMed.repeatInterval,
            },
          ));
      _medications[idx] = newMed;
      notifyListeners();
    }
  }
}
