import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sample_app/model/therapistmodel.dart';

class TherepistProvider with ChangeNotifier {
  List<TherapistModel> _therapist = [];
  final url = 'http://127.0.0.1:5000/therapists';

  List<TherapistModel> get items {
    return [..._therapist];
  }

  Future<void> add(String name, occupation) async {
    //final url = 'http://127.0.0.1:5000'; //TODO make this in an .ENV FILE
    Map<String, dynamic> request = {
      "name": name,
      "occupation": occupation,
    };
    final headers = {
      'Content-Type': 'application/json'
    };
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/add'), 
      headers: headers,
      body: json.encode(request)
    );
    Map<String, dynamic> responsePayload = json.decode(response.body);
    final thera = TherapistModel(name: responsePayload['name'], occupation: responsePayload['occupation']);
  }
}