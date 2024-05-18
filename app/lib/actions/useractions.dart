//import 'dart:convert';
//import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sample_app/model/therapistmodel.dart';
import 'package:sample_app/pages/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sample_app/pages/login.dart';
import 'package:sample_app/actions/therapist_provider.dart';
import 'package:provider/provider.dart';

final _firebaseAuth = FirebaseAuth.instance;

Future<void> register(String password, email, fname, lname, BuildContext context) async {
  String message = '';
  try {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim()
    );
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MyApp()));
    });
  } on FirebaseAuthMultiFactorException catch (e) {
    if (e.code == 'weak-password') {
      message = 'The password is too weak.';
    } else if (e.code == 'email-already-in-use') {
      message = 'An account already exists with that email.';
    }
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  } catch (err) {
      Fluttertoast.showToast(
      msg: "Failed: $err",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}

Future<void> login(String password, email, BuildContext context) async {
  String message = '';
  try {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim()
    );
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHome()));
    });
  } on FirebaseAuthMultiFactorException catch (e) {
    if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
      message = 'Invalid login credentials.';
    } else {
      message = e.code;
    }
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}

AlertDialog addtherapist(BuildContext context) {
  TextEditingController _name = TextEditingController();
  TextEditingController _occupation = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _department = TextEditingController();


  return AlertDialog(
    title: Text('Add Therapist/Employee'),
    content: 
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Add a therapist or Employee for employment purposes.'),
          SizedBox(height: 30),
          TextFormField(
            controller: _name,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextFormField(
            controller: _occupation,
            decoration: InputDecoration(
              labelText: 'Occupation',
            ),
          ),
          TextFormField(
            controller: _contact,
            decoration: InputDecoration(
              labelText: 'Contact Information',
            ),
          ),
          TextFormField(
            controller: _department,
            decoration: InputDecoration(
              labelText: 'Department',
            ),
          )
          ]),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Provider.of<TherepistProvider>(context, listen: false).add(_name.text, _occupation.text, _contact.text, _department.text);
          Navigator.of(context).pop();          
        }, 
        child: Text('Add')
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        }, 
        child: Text('Cancel')
      ),
    ],
  );
}

Future<void> deleteTherapist(String therapistID, BuildContext context) async {
  try {
    final url = 'http://127.0.0.1:5000/therapists/$therapistID';
    final response = await http.delete(Uri.parse(url));
  } catch (err) {
    print(err);
  }
  Provider.of<TherepistProvider>(context, listen: false).getTherapists;
}

AlertDialog updateTherapist(BuildContext context, String therapistID) {
  TextEditingController _name = TextEditingController();
  TextEditingController _occupation = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _department = TextEditingController();


  return AlertDialog(
    title: Text('Update Therapist details'),
    content: 
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Update the therapist\'s details.'),
          SizedBox(height: 30),
          TextFormField(
            controller: _name,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextFormField(
            controller: _occupation,
            decoration: InputDecoration(
              labelText: 'Occupation',
            ),
          ),
          TextFormField(
            controller: _contact,
            decoration: InputDecoration(
              labelText: 'Contact Information',
            ),
          ),
          TextFormField(
            controller: _department,
            decoration: InputDecoration(
              labelText: 'Department',
            ),
          )
          ]),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Provider.of<TherepistProvider>(context, listen: false).update(therapistID, _name.text, _occupation.text, _contact.text, _department.text);
          Navigator.of(context).pop();          
        }, 
        child: Text('Update')
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        }, 
        child: Text('Cancel')
      ),
    ],
  );
}