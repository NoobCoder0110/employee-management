import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/authentication/models/org/org_model.dart';


class SharedPreferencesHelper {
  static const String _orgKey = 'orgData';

  /// Save the entire OrgModel as JSON
  static Future<void> saveOrganization(OrgModel org) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(org.toJson());
    await prefs.setString(_orgKey, jsonString);
  }

  /// Retrieve OrgModel from SharedPreferences
  static Future<OrgModel?> getOrganization() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_orgKey);

    if (jsonString != null && jsonString.isNotEmpty) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return OrgModel.fromJson(jsonMap);
    }
    return null;
  }

  /// Check if organization data is saved
  static Future<bool> hasOrganization() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_orgKey);
  }

  /// Clear organization data (e.g. on logout)
  static Future<void> clearOrganization() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_orgKey);
  }
}
