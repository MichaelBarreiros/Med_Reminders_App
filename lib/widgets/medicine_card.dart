import 'package:flutter/material.dart';

import '../models/medicine.dart';
import './medicine_details.dart';
import './medicine_icon.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final Function goToEditPage;
  const MedicineCard(this.medicine, this.goToEditPage, {Key? key})
      : super(key: key);

  void _onTapFunction(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) {
        return MedicineDetails(medicine, this.goToEditPage);
      },
    ));
    // .then((medicine) {
    //   if (medicine != null) removeReminder(medicine, true);
    // });
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
              MedicineIcon(medicine, 50),
              Text(
                medicine.medicineName,
                textAlign: TextAlign.center,
              ),
              Text(
                medicine.repeatInterval,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
