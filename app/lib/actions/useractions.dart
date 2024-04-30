import 'dart:convert';
import 'dart:js';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sample_app/pages/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _firebaseAuth = FirebaseAuth.instance;

Future<void> register(String password, email, BuildContext context) async {
  String message = '';
  try {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim()
    );
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(context as BuildContext, MaterialPageRoute(builder: (context) => const home()));
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
      msg: "Failed: $e",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}

Future<void> login(String email, password) async {
    final Map<String, dynamic> postData = {
    'password': password,
    'email': email,
  };
  //TODO error here
  final response = await http.post(
    Uri.http('localhost:5000', '/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(postData),
  );
  try {
    if (response.statusCode == 201) {
      print('Data posted successfuly!');
    }
  } catch (err) {
    throw Exception(err);
  }
}
