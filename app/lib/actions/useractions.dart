import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> register(String username, password, email) async {
  final Map<String, dynamic> postData = {
    'username': username,
    'password': password,
    'email': email,
  };
  final response = await http.post(
    Uri.http(dotenv.env['djangoIP']!, 'registeruser'),
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
