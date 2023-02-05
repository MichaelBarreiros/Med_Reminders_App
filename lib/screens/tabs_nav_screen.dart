import 'package:flutter/material.dart';
import 'package:med_reminders_app/api/notification_api.dart';
import '../providers/appointments_provider.dart';
import '../providers/medicines_provider.dart';
import 'package:med_reminders_app/widgets/notification_details.dart';
import 'package:med_reminders_app/widgets/trackRx_app_bar.dart';
import 'package:provider/provider.dart';

import '../models/appointment.dart';
import '../widgets/nav_side_drawer.dart';
import './add_reminders_screen.dart';
import './calendar_view_screen.dart';
import './fda_search_screen.dart';
import './reminders_screen.dart';
import '../models/medicine.dart';

class TabsNavScreen extends StatefulWidget {
  static String routeName = '/tabs_navigation_screen';

  TabsNavScreen();

  @override
  _TabsNavScreenState createState() => _TabsNavScreenState();
}

class _TabsNavScreenState extends State<TabsNavScreen> {
  List<Map<String, Object>> pages = [];
  List<Medicine> medReminders = [];
  List<Appointment> appointmentReminders = [];

  int _selectedPageIndex = 0;

  String editId = '';

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
      pages[1]["title"] = "Add A New Reminders";
      pages[1]["page"] = AddRemindersScreen(_goToRemindersPage, '');
    });
  }

  void _goToRemindersPage() {
    setState(() {
      _selectedPageIndex = 0;
    });
  }

  void _goEditPage(String Id) {
    setState(() {
      _selectedPageIndex = 1;
      editId = Id;
      pages[1]["title"] = "Edit Your Reminder";
      pages[1]["page"] = AddRemindersScreen(_goToRemindersPage, editId);
    });
  }

  void listenNotification() {
    NotificationApi.onNotications.stream.listen(onClickedNotification);
  }

  void onClickedNotification(String? payload) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => NotificationDetails(),
        settings: RouteSettings(
          arguments: Medicine.fromJsonString(payload!),
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    pages = [
      {
        "title": "View Reminders",
        "page": RemindersScreen(_goEditPage),
      },
      {
        "title": "Add A New Reminders",
        "page": AddRemindersScreen(_goToRemindersPage, editId),
      },
      {
        "title": "FDA Search",
        "page": FdaSearchScreen(),
      },
      {
        "title": "Calendar View",
        "page": CalendarViewScreen(),
      },
    ];

    NotificationApi.init(initScheduled: true);
    listenNotification();
  }

  // testNotification() {
  //   Medicine med = widget.medReminders[0];
  //   DateTime meetingTime = DateTime.now().add(Duration(seconds: 1));

  //   NotificationApi.showScheduledNotification(
  //     scheduledDate: meetingTime,
  //     payload: med.toJsonString(),
  //     title: 'Time to take your ${med.medicineName}',
  //     body: 'Click to View Reminder Details',
  //   );

  //   print('notification scheduled for ${meetingTime.toString()}');
  // }

  @override
  Widget build(BuildContext context) {
    final medData = Provider.of<Medicines_Provider>(context);
    medReminders = medData.medications;

    final appointmentData = Provider.of<Appointments_Provider>(context);
    appointmentReminders = appointmentData.appointments;

    return Scaffold(
      appBar: buildAppBar(pages[_selectedPageIndex]["title"] as String),
      drawer: NavSideDrawer(),
      body: pages[_selectedPageIndex]["page"] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        // type: BottomNavigationBarType.fixed,
        onTap: _selectPage,
        elevation: 20,
        // backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Color(0xFF6200EE),
        selectedItemColor: Color(0xFF6200EE),
        currentIndex: _selectedPageIndex,
        selectedLabelStyle:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        unselectedLabelStyle:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        selectedIconTheme: IconThemeData(size: 30),
        unselectedIconTheme: IconThemeData(size: 30),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: "View",
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add",
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Calendar",
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.alarm),
      //   onPressed: testNotification,
      // ),
    );
  }
}
