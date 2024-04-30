import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> register(String password, email) async {
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
