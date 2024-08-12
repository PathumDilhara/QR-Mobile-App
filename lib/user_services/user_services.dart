// this file created to handle the shared preferences

import 'package:shared_preferences/shared_preferences.dart';

class UserServices{
  // method to store user login state as String
  static Future<void> storeLoginState (String? loginState) async { // ? for can be null
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("loginState", loginState!); // ! for cannot be null
  }

  // Method to check the loginState is saved in shared Preferences
  static Future<String> checkLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginState = prefs.getString("loginState");
    return loginState!; // if null return false
  }

  // Method to clear login state
  // Use await UserServices.clearSavedLoginState();
  static Future<void> clearSavedLoginState () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("loginState");
  }

}