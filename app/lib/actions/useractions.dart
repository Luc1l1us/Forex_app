//import 'dart:convert';
//import 'dart:math';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sample_app/model/therapistmodel.dart';
import 'package:sample_app/pages/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sample_app/pages/landingpage.dart';
import 'package:sample_app/pages/login.dart';
import 'package:sample_app/actions/user_provider.dart';
import 'package:provider/provider.dart';

final _firebaseAuth = FirebaseAuth.instance;

Future<void> register(String password, email, fname, lname, DateTime bdate, BuildContext context) async {
  String message = '';
  try {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim()
    );

    User? currentUser = userCredential.user;
    if (currentUser == null) {
      throw Exception("User creation failed!");
    }
    final String uid = currentUser.uid;
    print('Birthday: $bdate');
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'uid': uid.trim(),
        'email': email.trim(),
        'firstname': fname.trim(),
        'lastname': lname.trim(),
        'birthday': bdate.toIso8601String(),
      })
    );

    if (response.statusCode == 201) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MyApp()));
      });
    } else {
      throw Exception('Failed to add user information!');
    }

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
      Navigator.push(context, MaterialPageRoute(builder: (context) => const landingpage()));
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

//TODO: adding user but this is not admin anyway
/* AlertDialog addtherapist(BuildContext context) {
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
          Provider.of<UserProvider>(context, listen: false).add(_name.text, _occupation.text, _contact.text, _department.text);
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
} */

//TODO: deleting user records might be handy here
/* Future<void> deleteTherapist(String therapistID, BuildContext context) async {
  try {
    final url = 'http://127.0.0.1:5000/therapists/$therapistID';
    final response = await http.delete(Uri.parse(url));
  } catch (err) {
    print(err);
  }
  Provider.of<UserProvider>(context, listen: false).getTherapists;
} */

//TODO: Update method for later
/* AlertDialog updateTherapist(BuildContext context, String therapistID) {
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
} */