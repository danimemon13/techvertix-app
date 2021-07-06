import 'package:shared_preferences/shared_preferences.dart';


class SessionManager {
  final String id = "auth_token";
  final String device_id = "device_id";
  final String company_id = "company_id";

  bool isLoggedIn = false;

//set data into shared preferences like this
  Future<void> setAuthToken(String auth_token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.id, auth_token);
  }
  Future<void> setDeviceId(String device_id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.device_id, device_id);
  }
  Future<void> setCompanyId(String company_id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.company_id, company_id);
  }

//get value from shared preferences
  Future<String> getAuthToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String auth_token;
    auth_token = pref.getString(this.id) ?? null;
    return auth_token;
  }
  Future<String> getDeviceId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String device_id;
    device_id = pref.getString(this.device_id) ?? null;
    return device_id;
  }
  Future<String> getCurrentUserCompanyID() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String company_id;
    company_id = pref.getString(this.company_id) ?? null;
    return company_id;
  }

  Future<String> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.id, "");
      isLoggedIn = false;
  }
}

