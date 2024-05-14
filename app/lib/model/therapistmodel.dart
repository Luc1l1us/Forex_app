import 'dart:convert';
class TherapistModel {
  String id;
  String name;
  String occupation;
  String contact;
  String department;

  TherapistModel({
    required this.id,
    required this.name,
    required this.occupation,
    required this.contact,
    required this.department,
  });

  factory TherapistModel.fromJson(Map<String, dynamic> json) {
    return TherapistModel(
      id: '',
      name: json['name'] ?? '',
      occupation: json['occupation'] ?? '',
      contact: json['contact'] ?? '',
      department: json['department'] ?? '',
    );
  }
}

List<TherapistModel> parseTherapists(String responseBody) {
  final Map<String, dynamic> therapistsMap = json.decode(responseBody);
  return therapistsMap.entries
    .map((e) => TherapistModel.fromJson(e.value))
    .toList();
}