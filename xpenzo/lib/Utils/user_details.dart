import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  saveFirstName(String fname) async {
    // To save a string value
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', fname);

// To retrieve a string value
// SharedPreferences prefs = await SharedPreferences.getInstance();
// String myValue = prefs.getString('myKey');
  }

  saveLastName(String lname) async {
    // To save a string value
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastname', lname);

// To retrieve a string value
// SharedPreferences prefs = await SharedPreferences.getInstance();
// String myValue = prefs.getString('myKey');
  }

  Future<String> getFirstName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('firstName');
    debugPrint('From Shared Preference Funtion: $name');
    return name ?? 'Guest';
  }

  Future<String> getLastName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('lastname');
    debugPrint('From Shared Preference Funtion: $name');
    return name ?? 'User';
  }

  saveProfilePath(String pathname) async {
    // To save a string value
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('picturePath', pathname);

// To retrieve a string value
// SharedPreferences prefs = await SharedPreferences.getInstance();
// String myValue = prefs.getString('myKey');
  }

  getProfilePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString('picturePath');
    return path ?? 'assets/icons/man.png';
  }
}
