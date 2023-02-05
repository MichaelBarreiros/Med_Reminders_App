import 'package:flutter/material.dart';
import 'package:med_reminders_app/models/http_exception.dart';
import '../providers/auth.dart';
import '../widgets/trackRx_app_bar.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import './tabs_nav_screen.dart';

enum AuthMode { Signup, Login }

class LoginPage extends StatelessWidget {
  static const routeName = '/login';
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('Login Page'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 90),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Ink.image(
                  image: AssetImage('assets/images/flutter_logo.png'),
                  fit: BoxFit.cover,
                  width: 128,
                  height: 128,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'TrackRX',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: Color(0xFF6200EE),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            AuthCard(),

            // const Padding(
            //   padding: EdgeInsets.all(10),
            //   child: TextField(
            //     keyboardType: TextInputType.emailAddress,
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //       labelText: 'Email',
            //       hintText: 'Enter a valid email',
            //     ),
            //   ),
            // ),
            // const Padding(
            //   padding: EdgeInsets.all(10),
            //   child: TextField(
            //     obscureText: true,
            //     decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         labelText: 'Password',
            //         hintText: 'Enter your secure password'),
            //   ),
            // ),
            // Container(
            //   height: 50,
            //   width: 250,
            //   decoration: BoxDecoration(
            //       color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            //   child: TextButton(
            //     onPressed: () {
            //       Navigator.pushReplacementNamed(
            //           context, TabsNavScreen.routeName);
            //     },
            //     child: const Text(
            //       'Login',
            //       style: TextStyle(color: Colors.white, fontSize: 25),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("An error occured"),
        content: Text(errorMessage),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Okay'))
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'], _authData['password']);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email'], _authData['password']);
      }
      // Navigator.pushReplacementNamed(context, TabsNavScreen.routeName);

    } on HttpException catch (error) {
      var errorMessage = "Authentication Failed";

      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = "This email address is already in use.";
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = "This is not a valid email address.";
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = "This password is too weak.";
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = "Could not find user with that email.";
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = "Invalid Password";
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = "Could not authenticate you. Try Again.";
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.90,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Color(0xFF6200EE),
                    textColor: Colors.white,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Colors.white,
                  color: Color(0xFF6200EE),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
