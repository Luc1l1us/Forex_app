import 'dart:html';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login.dart';

class register_page extends StatefulWidget{
  const register_page({super.key});

  @override
  State<register_page> createState() => _registerpage();
}

class _registerpage extends State<register_page> { 
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(100),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: 'Enter your email',
              ),
              controller: _email,
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: 'Enter your password',
              ),
              controller: _password,
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
            RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: "Not yet Registered?  "
                ),
                TextSpan(
                  text: "Register",
                  style: TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()..onTap = () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const register_page()));
                  }
                )
              ]
            )),
            SizedBox(height: 50),
            TextButton(
                onPressed: () {
                  try {
                    register(_email.text, _password.text);
                  } catch (err) {
                    throw Exception(err);
                  }
                },
                child: Text('Sign In'))
          ],
        ),
      ),
    )
    );
  }
}