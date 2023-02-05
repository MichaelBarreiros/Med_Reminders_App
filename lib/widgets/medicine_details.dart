import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/medicines_provider.dart';
import 'package:provider/provider.dart';

import '../models/medicine.dart';
import './medicine_icon.dart';
import './trackRx_app_bar.dart';

class MedicineDetails extends StatelessWidget {
  final Medicine medicine;
  final Function goToEditPage;

  const MedicineDetails(this.medicine, this.goToEditPage, {Key? key})
      : super(key: key);

  Future<void> _onDeletePressed(BuildContext context) async {
    try {
      await Provider.of<Medicines_Provider>(context, listen: false)
          .removeMedication(medicine.id);
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
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(medicine.medicineName),
      body: Container(
        height: 700,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                goToEditPage(medicine.id);
                Navigator.of(context).pop();
              },
              child: Icon(Icons.edit),
              heroTag: null,
            ),
            FloatingActionButton(
              onPressed: () => _onDeletePressed(context),
              child: Icon(Icons.delete),
              heroTag: null,
            ),
          ],
        ),
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
        MedicineIcon(medicine, 80),
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
                    fieldInfo: medicine.medicineName),
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
      crossAxisAlignment: CrossAxisAlignment.center,
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
      height: 75,
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
        ExtendedInfoTab(
          fieldTitle: 'Start Date',
          fieldInfo: (DateFormat.yMMMMd().format(medicine.startDate)),
        ),
        ExtendedInfoTab(
          fieldTitle: 'End Date',
          fieldInfo: (DateFormat.yMMMMd().format(medicine.endDate)),
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
      padding: const EdgeInsets.symmetric(vertical: 10),
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
