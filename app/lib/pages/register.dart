import 'dart:html';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../actions/useractions.dart';
import 'login.dart';

bool _passwordVisible = false;
class register_page extends StatefulWidget{
  const register_page({super.key});

  @override
  State<register_page> createState() => _registerpage();
}

@override
  void initState() {
    _passwordVisible = false;
}

class _registerpage extends State<register_page> { 
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(100),
          child: Form(
            key: _form, 
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _email,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: 'Enter your email',
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Empty';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _password,
              obscureText: !_passwordVisible,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Empty';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: 'Password',
                hintText: 'Enter your password',
                suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                )
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _confirmpassword,
              obscureText: !_passwordVisible,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Empty';
                }
                if (val != _password.text) {
                  return 'Passwords do not match!';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: 'Confirm Password',
                hintText: 'Confirm your password',
                suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                )
              ),
            ),
            SizedBox(height: 30),
            Text("or"),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                //logic here
              },
              icon: FaIcon(FontAwesomeIcons.google), 
              label: Text('Sign in with Google'
            )),
            SizedBox(height: 30),
            SizedBox(height: 50),
            TextButton(
                onPressed: () {
                  _form.currentState?.validate();
                  try {
                    register(_password.text, _email.text, context);
                  } catch (err) {
                    throw Exception(err);
                  }
                },
                child: Text('Create Account'))
          ],
        ),
      ),
    )
    ));
  }
}