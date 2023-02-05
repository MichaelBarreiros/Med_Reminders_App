import 'package:flutter/material.dart';
import 'package:med_reminders_app/main.dart';
import 'package:med_reminders_app/models/user.dart';
import 'package:med_reminders_app/utils/user_preferences.dart';
import 'package:med_reminders_app/widgets/profile_widget.dart';
import 'package:med_reminders_app/widgets/text_field_widget.dart';
import 'package:med_reminders_app/widgets/trackRx_app_bar.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/editProfileScreen';
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  User user = UserPreferences.myUser;

  void onCancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('Account Information'),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 32,
        ),
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: 12),
          ProfileWidget(
            imagePath: user.imagePath,
            isEdit: true,
            onClicked: () {},
          ),
          const SizedBox(height: 18),
          TextFieldWidget(
            label: 'Full Name',
            text: user.name,
            onChanged: (name) {},
          ),
          const SizedBox(height: 10),
          TextFieldWidget(
            label: 'Email',
            text: user.email,
            onChanged: (email) {},
          ),
          const SizedBox(height: 10),
          TextFieldWidget(
            label: 'Emergency Contact Name',
            text: user.emergencyContactName,
            onChanged: (name) {},
          ),
          const SizedBox(height: 10),
          TextFieldWidget(
            label: 'Emergency Contact Number',
            text: user.emergencyContactNumber,
            onChanged: (number) {},
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () => onCancel(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                style: TextButton.styleFrom(backgroundColor: Colors.red),
              ),
              TextButton(
                onPressed: () => onCancel(context),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary),
              ),
            ],
          )
        ],
      ),
    );
  }
}
