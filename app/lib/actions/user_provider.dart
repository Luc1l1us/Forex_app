import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity/connectivity.dart';
import 'package:sample_app/databasehelper/databasehelper.dart';
import 'package:sample_app/pages/signuplogin.dart';

class UserProvider with ChangeNotifier {
  late final DatabaseHelper _databaseHelper;

  UserProvider() {
    _databaseHelper = DatabaseHelper();
    _databaseHelper.initializeDatabase();
  }

  List<Map<String, dynamic>> _users = [];
  Map<String, dynamic> _user = {};
  bool _isUserLoaded = false;
  final url = 'http://127.0.0.1:5000/getusers';

  Map<String, dynamic> get user => _user;
  bool get isUserLoaded => _isUserLoaded;

  List<Map<String, dynamic>> get items {
    return [..._users];
  }

  Future<void> updateFirstName(String newName) async {
  var connectivityResult = await Connectivity().checkConnectivity();
  var response;
  try {
    if (connectivityResult != ConnectivityResult.none) {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user is logged in!");
      }
      final String userId = currentUser.uid;

      final Map<String, dynamic> requestData = {
        "field": "firstname",
        "value": newName,
      };

      response = await http.put(
        Uri.parse('http://127.0.0.1:5000/update/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData)
      );

      if (response.statusCode == 200) {
        print('Name updated successfully');
        fetchUserFromApi();
      } else {
        print('Failed to update name. Status code: ${response.statusCode}');
      }
    } else {
      await _databaseHelper.updateFirstName(newName);
      print('Name updated locally!');
    }
  } catch (error) {
    print('Error updating name: $error');
  }
}

  Future<void> updateLastName(String newName) async {
  var response;
  try {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("No user is logged in!");
    }
    final String userId = currentUser.uid;

    final Map<String, dynamic> requestData = {
      "field": "lastname",
      "value": newName,
    };

    response = await http.put(
      Uri.parse('http://127.0.0.1:5000/update/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestData)
    );

    if (response.statusCode == 200) {
      print('Name updated successfully');
      fetchUserFromApi();
    } else {
      print('Failed to update name. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error updating name: $error');
  }
}

Future<void> updateUsername(String newUsername) async {
  var response;
  try {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("No user is logged in!");
    }
    final String userId = currentUser.uid;

    final Map<String, dynamic> requestData = {
      "field": "username",
      "value": newUsername,
    };

    response = await http.put(
      Uri.parse('http://127.0.0.1:5000/update/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestData)
    );

    if (response.statusCode == 200) {
      print('Name updated successfully');
      fetchUserFromApi();
    } else {
      print('Failed to update name. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error updating name: $error');
  }
}

Future<void> updateEmail(String newEmail) async {
  var response;
  try {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("No user is logged in!");
    }
    final String userId = currentUser.uid;

    final Map<String, dynamic> requestData = {
      "field": "email",
      "value": newEmail,
    };

    response = await http.put(
      Uri.parse('http://127.0.0.1:5000/update/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestData)
    );

    if (response.statusCode == 200) {
      print('Name updated successfully');
      fetchUserFromApi();
    } else {
      print('Failed to update name. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error updating name: $error');
  }
}

Future<void> deleteUser(BuildContext context) async {
  var response;
  try {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("No user is logged in!");
    }
    final String userId = currentUser.uid;

    response = await http.delete(
      Uri.parse('http://127.0.0.1:5000/delete/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 204) {
      print('User deleted successfully');
      await currentUser.delete();
      await FirebaseAuth.instance.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context) => signuplogin()));
    } else {
      print('Failed to update name. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error updating name: $error');
  }
}

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
}