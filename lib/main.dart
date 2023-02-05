import 'package:flutter/material.dart';
import './providers/auth.dart';
import './providers/appointments_provider.dart';
import './screens/edit_account_information_screen.dart';
import 'package:provider/provider.dart';

import './api/notification_api.dart';
import './screens/login_page.dart';
import './screens/tabs_nav_screen.dart';
import './widgets/notification_details.dart';
import './models/medicine.dart';
import './models/appointment.dart';
import './screens/account_information_screen.dart';
import './providers/medicines_provider.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Medicine> medReminders = [];
  List<Appointment> appointmentReminders = [];

  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFF6200EE, color);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Medicines_Provider>(
          create: (ctx) => Medicines_Provider(),
          update: (ctx, auth, prevProvider) {
            prevProvider!..authToken = auth.token ?? '';
            prevProvider..userId = auth.userId ?? '';
            return prevProvider;
          },
        ),
        ChangeNotifierProxyProvider<Auth, Appointments_Provider>(
          create: (ctx) => Appointments_Provider(),
          update: (ctx, auth, prevProvider) {
            prevProvider!..authToken = auth.token ?? '';
            prevProvider..userId = auth.userId ?? '';
            return prevProvider;
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'TrackRx Medical Reminders',
          theme: ThemeData(
            primarySwatch: colorCustom,
            primaryColor: Colors.white,
            accentColor: Colors.black,
            fontFamily: 'Raleway',
            textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: const TextStyle(
                  color: Colors.purple,
                ),
                bodyText2: const TextStyle(
                  color: Colors.purple,
                ),
                headline6: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                )),
          ),
          home: auth.isAuth ? TabsNavScreen() : LoginPage(),
          routes: {
            EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
            AccountInformationScreen.routeName: (ctx) =>
                AccountInformationScreen(),
            TabsNavScreen.routeName: (ctx) => TabsNavScreen(),
          },
        ),
      ),
    );
  }
}
