import 'package:flutter/material.dart';

import './edit_account_information_screen.dart';
import '../models/user.dart';
import '../widgets/profile_widget.dart';
import '../utils/user_preferences.dart';
import '../widgets/nav_side_drawer.dart';
import '../widgets/trackRx_app_bar.dart';

class AccountInformationScreen extends StatefulWidget {
  static String routeName = '/AccountInformationScreen';

  const AccountInformationScreen({Key? key}) : super(key: key);

  @override
  _AccountInformationScreenState createState() =>
      _AccountInformationScreenState();
}

class _AccountInformationScreenState extends State<AccountInformationScreen> {
  Widget buildName(User user) {
    return Column(
      children: [
        Text(
          user.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFF6200EE),
          ),
        ),
        Text(
          user.email,
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ],
    );
  }

  Widget buildEmergencyContact(User user) {
    return Column(
      children: [
        Text(
          'Emergency Contact',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Color(0xFF6200EE),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          user.emergencyContactName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFF6200EE),
          ),
        ),
        Text(
          user.emergencyContactNumber,
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ],
    );
  }

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
  }

  Widget buildEditIcon(Color color) {
    return buildCircle(
      color: color,
      all: 14,
      child: Icon(
        Icons.edit,
        size: 30,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;

    return Scaffold(
      appBar: buildAppBar('Account Information'),
      drawer: NavSideDrawer(),
      body: ListView(
        children: [
          SizedBox(height: 12),
          ProfileWidget(
              imagePath: user.imagePath,
              onClicked: () {
                Navigator.of(context).pushNamed(EditProfileScreen.routeName);
              }),
          const SizedBox(
            height: 24,
          ),
          buildName(user),
          const SizedBox(
            height: 100,
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 40,
          //     vertical: 10,
          //   ),
          //   child: Divider(
          //     color: Colors.black,
          //     thickness: 1,
          //   ),
          // ),
          buildEmergencyContact(user),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: buildEditIcon(Theme.of(context).colorScheme.primary),
        onPressed: () =>
            Navigator.of(context).pushNamed(EditProfileScreen.routeName),
      ),
    );
  }
}
