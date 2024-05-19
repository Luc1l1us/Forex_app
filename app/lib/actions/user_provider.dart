import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  List<Map<String, dynamic>> _users = [];
  Map<String, dynamic> _user = {};
  bool _isUserLoaded = false;
  final url = 'http://127.0.0.1:5000/getusers';

  Map<String, dynamic> get user => _user;
  bool get isUserLoaded => _isUserLoaded;

  List<Map<String, dynamic>> get items {
    return [..._users];
  }

  //TODO: Adding therapists but we do not need it anymore
/*   Future<void> add(String name, occupation, contact, department) async {
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
  } */
  
//TODO: Update method for later too
/*   Future<void> update(String therapistId, String newName, newOccupation, newContact, newDepartment) async {
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
  } */

  Future<String?> getCurrentUserUID() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> fetchUserFromApi() async {
    var response;
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user is logged in!");
      }
      final String userId = currentUser.uid;
      response = await http.get(Uri.parse('http://127.0.0.1:5000/getusers/$userId'));
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> user = json.decode(response.body);
        _user = user;
        _isUserLoaded = true;
      } else {
        print('Failed to load user: ${response.statusCode}');
      }
    } catch (err) {
      print('Error fetching user: $err');
    }
    notifyListeners();
  }

/* 
  Future<void> get getTherapists async {
    var response;
    try {
      response = await http.get(Uri.parse('http://127.0.0.1:5000/getusers'));
      print(response.body);
      //TODO body has error, get idea from past project
      List<Map<String, dynamic>> users = parseUsers(response.body);
      _users = users;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  } */
  
  Map<String, dynamic> parseUsers(String responseBody) {
    final Map<String, dynamic> therapistsMap = json.decode(responseBody);
    return therapistsMap.map((key, value) => MapEntry(key, {
      "id": key,
      "email": value['email'] ?? '',
      "firstName": value['First Name'] ?? '',
      "lastName": value['Last Name'] ?? '',
      "birthday": value['birthday'] != null ? DateTime.parse(value['birthday']) : null,
    }));
  }

/*   Future<void> loadUser() async {
    String? userId = await getCurrentUserUID();
    if (userId != null) {
      await fetchUserFromApi(userId);
    }
  } */
}