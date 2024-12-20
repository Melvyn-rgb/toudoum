import 'dart:convert';
import 'package:flutter/services.dart';

class Localization {
  final String locale;
  late Map<String, String> _localizedStrings;

  Localization(this.locale);

  Future<void> load() async {
    String jsonString = await rootBundle.loadString('assets/lang/$locale.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  String get(String key) {
    return _localizedStrings[key] ?? key;
  }
}
