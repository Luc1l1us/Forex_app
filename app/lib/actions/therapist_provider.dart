import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sample_app/model/therapistmodel.dart';

class TherepistProvider with ChangeNotifier {
  List<Map<String, dynamic>> _therapist = [];
  final url = 'http://127.0.0.1:5000/therapists';

  List<Map<String, dynamic>> get items {
    return [..._therapist];
  }

  Future<void> add(String name, occupation, contact, department) async {
    //final url = 'http://127.0.0.1:5000'; //TODO make this in an .ENV FILE
    Map<String, dynamic> request = {
      "name": name,
      "occupation": occupation,
      "contact": contact,
      "department": department,
    };
    final headers = {
      'Content-Type': 'application/json'
    };
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/add'), 
      headers: headers,
      body: json.encode(request)
    );

    if (response.statusCode == 200) {
      await getTherapists;
    }
    getTherapists;
    notifyListeners();
  }
  
  Future<void> update(String therapistId, String newName, newOccupation, newContact, newDepartment) async {
      final url = 'http://127.0.0.1:5000/update/$therapistId';
      final headers = {'Content-Type': 'application/json'};
      final updatedTherapistMap =  {
          'id': therapistId,
          'name': newName,
          'occupation': newOccupation,
          "contact": newContact,
          "department": newDepartment,

        };
      /* final request = {
        'name': newName,
        'occupation': newOccupation,
      }; */
    var response;
    try {
      response = await http.put(
        Uri.parse(url), 
        headers: headers, 
        body: json.encode(updatedTherapistMap)
      );
        // Update local list of therapists with the updated data
        final index = _therapist.indexWhere((therapist) => therapist['id'] == therapistId);
        _therapist[index] = updatedTherapistMap;
    } catch (err) {
      print(err);
    }
    notifyListeners();      
  }


  Future<void> get getTherapists async {
    var response;
    try {
      response = await http.get(Uri.parse('http://127.0.0.1:5000/gettherapists'));
      print(response.body);
      //TODO body has error, get idea from past project
      List<Map<String, dynamic>> therapists = parseTherapists(response.body);
      _therapist = therapists;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }
  
  List<Map<String, dynamic>> parseTherapists(String responseBody) {
    final Map<String, dynamic> therapistsMap = json.decode(responseBody);
    return therapistsMap.entries
    .map((e) => {
      "id": e.key,
      "name": e.value['name'] ?? '',
      "occupation": e.value['occupation'] ?? '',
      "contact": e.value['contact'] ?? '',
      "department": e.value['department'] ?? ''
    })
    .toList();
  }
}