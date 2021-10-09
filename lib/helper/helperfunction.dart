import "package:shared_preferences/shared_preferences.dart";

class HelperFunctions {
  static String sharedPreferencesLoggedInKey = '  ISLOGGEDIN';
  static String sharedPreferencedUserNameKey = 'USERNAEMKEY';
  static String sharedPreferencedUserEmailKey = 'USEREMAILKEY';
  static String sharedPreferencesDoesUserHasPin = 'DOESUSERHASPIN';
  static String sharedPreferencesUserPin = 'USERPIN';
  static String sharedPreferencesSecretUserMap = 'SECRETUSERMAP';

  static Future<bool> saveUserLoggedInSharedPrefrences(
      bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferencesLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPrefrences(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencedUserNameKey, userName);
  }

  static Future<bool> saveUserEmailSharedPrefrences(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencedUserEmailKey, userEmail);
  }

  static Future<bool> saveUserHasPinStatus(bool doesUserHasPin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferencesDoesUserHasPin, doesUserHasPin);
  }

  static Future<bool> saveUserPin(String userPin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesUserPin, userPin);
  }

  static Future<bool> saveSecretUserMap(String userMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesSecretUserMap, userMap);
  }

  static Future<bool> getUserLoggedInSharedPrefrences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferencesLoggedInKey);
  }

  static Future<String> getEmailInSharedPrefrences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencedUserEmailKey);
  }

  static Future<String> getUserNameSharedPrefrences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencedUserNameKey);
  }

  static Future<bool> getUserHasPinStatusSharedPrefrences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferencesDoesUserHasPin);
  }

  static Future<String> getUserPinSharedPrefrences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencesUserPin);
  }

  static Future<String> getUserSecretMap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencesSecretUserMap);
  }
}
