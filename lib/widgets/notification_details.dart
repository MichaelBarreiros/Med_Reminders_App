import 'package:flutter/material.dart';

import '../models/medicine.dart';
import './medicine_icon.dart';
import './trackRx_app_bar.dart';

class NotificationDetails extends StatelessWidget {
  late Medicine medicine;
  static String routeName = '/notification_details';

  void _onConfirm(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    medicine = ModalRoute.of(context)!.settings.arguments as Medicine;

    return Scaffold(
      appBar: buildAppBar('Notification for ${medicine.medicineName}'),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainSection(medicine),
            const SizedBox(height: 15),
            ExtendedSection(medicine),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onConfirm(context),
        child: Icon(Icons.check),
      ),
    );
  }
}

class MainSection extends StatelessWidget {
  final Medicine medicine;
  const MainSection(this.medicine, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        MedicineIcon(medicine, 175),
        const SizedBox(
          width: 15,
        ),
        Column(
          children: <Widget>[
            Hero(
              tag: medicine.medicineName,
              child: Material(
                color: Colors.transparent,
                child: MainInfoTab(
                  fieldTitle: "Medicine Name",
                  fieldInfo: medicine.medicineName,
                ),
              ),
            ),
            MainInfoTab(
              fieldTitle: "Dosage",
              fieldInfo: medicine.dosage == 0
                  ? "Not Specified"
                  : medicine.dosage.toString() + " mg",
            )
          ],
        )
      ],
    );
  }
}

class MainInfoTab extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;

  MainInfoTab({
    required this.fieldTitle,
    required this.fieldInfo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      height: 100,
      child: ListView(
        padding: const EdgeInsets.only(top: 15),
        shrinkWrap: true,
        children: <Widget>[
          Text(
            fieldTitle,
            style: const TextStyle(
                fontSize: 17,
                color: Color(0xFFC9C9C9),
                fontWeight: FontWeight.bold),
          ),
          Text(
            fieldInfo,
            style: const TextStyle(
                fontSize: 24,
                color: Color(0xFF3EB16F),
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  final Medicine medicine;
  const ExtendedSection(this.medicine, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ExtendedInfoTab(
          fieldTitle: 'Medicine Type',
          fieldInfo: medicine.medicationType,
        ),
        ExtendedInfoTab(
          fieldTitle: 'Dose Interval',
          fieldInfo: medicine.repeatInterval,
        ),
        ExtendedInfoTab(
          fieldTitle: 'Time',
          fieldInfo: medicine.startTime.format(context),
        ),
      ],
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;

  const ExtendedInfoTab(
      {required this.fieldTitle, required this.fieldInfo, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              fieldTitle,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            fieldInfo,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFFC9C9C9),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
