import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/appointments_provider.dart';
import 'package:provider/provider.dart';

import './trackRx_app_bar.dart';
import '../models/appointment.dart';

class AppointmentDetails extends StatelessWidget {
  final Appointment appointment;
  final Function goToEditPage;

  const AppointmentDetails(this.appointment, this.goToEditPage, {Key? key})
      : super(key: key);

  Future<void> _onDeletePressed(BuildContext context) async {
    try {
      await Provider.of<Appointments_Provider>(context, listen: false)
          .removeAppointment(appointment.id);
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
      appBar: buildAppBar(appointment.appointmentName),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainSection(appointment),
            const SizedBox(height: 15),
            ExtendedSection(appointment),
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
                goToEditPage(appointment.id);
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
  final Appointment appointment;
  const MainSection(this.appointment, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.medical_services,
          size: 80,
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          children: <Widget>[
            Hero(
              tag: appointment.appointmentName,
              child: Material(
                color: Colors.transparent,
                child: MainInfoTab(
                  fieldTitle: "Appointment Name",
                  fieldInfo: appointment.appointmentName,
                ),
              ),
            ),
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
      width: MediaQuery.of(context).size.width * 0.52,
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
  final Appointment appointment;
  const ExtendedSection(this.appointment, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ExtendedInfoTab(
            fieldTitle: 'Appointment Date',
            fieldInfo: DateFormat.yMMMd().format(appointment.date)),
        ExtendedInfoTab(
          fieldTitle: 'Appointment Time',
          fieldInfo: appointment.time.format(context),
        ),
        ExtendedInfoTab(
          fieldTitle: 'Repeat Interval',
          fieldInfo: appointment.repeatInterval,
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
