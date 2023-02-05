import '../models/user.dart';

class UserPreferences {
  static const myUser = User(
    imagePath: 'assets/images/mcmaster_crest.png',
    name: 'McMaster Student',
    email: 'student@mcmaster.ca',
    emergencyContactName: 'Caretaker',
    emergencyContactNumber: '123-456-7890',
  );
}
