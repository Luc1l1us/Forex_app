import 'dart:convert';
class TherapistModel {
  String id;
  String name;
  String occupation;

  TherapistModel({
    required this.id,
    required this.name,
    required this.occupation,
  });

  factory TherapistModel.fromJson(Map<String, dynamic> json) {
    return TherapistModel(
      id: '',
      name: json['name'] ?? '',
      occupation: json['occupation'] ?? '',
    );
  }
}

List<TherapistModel> parseTherapists(String responseBody) {
  final Map<String, dynamic> therapistsMap = json.decode(responseBody);
  return therapistsMap.entries
    .map((e) => TherapistModel.fromJson(e.value))
    .toList();
}