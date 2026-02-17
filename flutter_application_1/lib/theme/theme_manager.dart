import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  late bool _isDark;

  // The current dark theme value
  bool get isDark => _isDark;

  // Read the current isDark value and set it to Theme Mode
  ThemeMode get themeMode => _isDark? ThemeMode.dark : ThemeMode.light;


  /// Load the initial bool value from persistent storage,
  /// or fallback to false if it doesn't exists.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDark') ?? false;

    log("isDark loaded to: ($_isDark)");
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// After a click, the value will change the opposite way, then
  /// asynchronously save it to persistent storage.
  Future<void> setMode() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = !(prefs.getBool('isDark') ?? false);
    
    // Save the current value to persistent storage.
    prefs.setBool('isDark', _isDark); 
    log("Saved to: ${prefs.getBool('isDark')} and current isDark is: ($_isDark)");
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}