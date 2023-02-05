import 'package:flutter/material.dart';

import '../models/appointment.dart';
import './appointment_details.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final Function goToEditPage;
  const AppointmentCard(this.appointment, this.goToEditPage, {Key? key})
      : super(key: key);

  void _onTapFunction(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) {
        return AppointmentDetails(appointment, goToEditPage);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.white,
      splashColor: Colors.grey,
      onTap: () => _onTapFunction(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          // border: Border.all(color: Color(0xFF6200EE)),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.medical_services, size: 40),
              Text(
                appointment.appointmentName,
                textAlign: TextAlign.center,
              ),
              Text(
                appointment.repeatInterval,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
