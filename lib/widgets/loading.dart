import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 150.0, 0.0, 0.0),
      child: SpinKitFadingCircle(
        color: Color(0xFF6200EE),
        size: 100.0,
      )
    );
  }
}
