import 'package:flutter/material.dart';

import '../models/medicine.dart';

class MedicineIcon extends StatelessWidget {
  final Medicine medicine;
  final double size;
  const MedicineIcon(this.medicine, this.size, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (medicine.medicationType == 'Tablet') {
      return Icon(
        IconData(0xe903, fontFamily: "Ic"),
        size: size,
      );
    } else if (medicine.medicationType == 'Pill') {
      return Icon(
        IconData(0xe901, fontFamily: "Ic"),
        size: size,
      );
    } else if (medicine.medicationType == 'Syringe') {
      return Icon(
        IconData(0xe902, fontFamily: "Ic"),
        size: size,
      );
    } else if (medicine.medicationType == 'Other') {
      return Icon(
        IconData(0xe900, fontFamily: "Ic"),
        size: size,
      );
    } else {
      return Icon(
        Icons.local_hospital,
        size: size,
      );
    }
  }
}
