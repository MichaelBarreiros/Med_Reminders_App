import 'package:flutter/material.dart';
import 'package:med_reminders_app/providers/auth.dart';
import 'package:provider/provider.dart';

import '../screens/account_information_screen.dart';
import '../screens/tabs_nav_screen.dart';

class NavSideDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, VoidCallback tapHandler,
      {Color? color}) {
    return ListTile(
        leading: Icon(
          icon,
          size: 26,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black54,
            fontFamily: "RobotoCondensed",
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: tapHandler,
        tileColor: color ?? Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    String? currentRouteName = ModalRoute.of(context)!.settings.name;
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            height: 120,
            alignment: Alignment
                .centerLeft, //vertically in the center, horizontally to the left
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Text(
              'TrackRx',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Color(0xFF6200EE)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildListTile('Home', Icons.home, () {
            if (currentRouteName == TabsNavScreen.routeName) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context)
                  .pushReplacementNamed(TabsNavScreen.routeName);
            }
          }),
          buildListTile('Account Information', Icons.person, () {
            if (currentRouteName == AccountInformationScreen.routeName) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context)
                  .pushReplacementNamed(AccountInformationScreen.routeName);
            }
          }),
          buildListTile('Logout', Icons.exit_to_app, () {
            Provider.of<Auth>(context, listen: false).logout();
          }, color: Colors.red),
        ],
      ),
    );
  }
}
