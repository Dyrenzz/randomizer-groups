import 'package:flutter/material.dart';

/// Dark Mode Neutral Palette
const MaterialColor darkMode = MaterialColor(
  0xFF38414A, // DarkNeutral600
  <int, Color>{
    50: Color(0xFF101214),    // DarkNeutral0
    100: Color(0xFF161A1D),   // DarkNeutral100
    200: Color(0xFF1D2125),   // DarkNeutral200
    300: Color(0xFF22272B),   // DarkNeutral300
    400: Color(0xFF282E33),   // DarkNeutral400
    500: Color(0xFF2C333A),   // DarkNeutral500
    600: Color(0xFF38414A),   // DarkNeutral600
    700: Color(0xFF454F59),   // DarkNeutral700
    800: Color(0xFF596773),   // DarkNeutral800
    900: Color(0xFF738496),   // DarkNeutral900
    950: Color(0xFF8C9BAB),   // DarkNeutral950
    1000: Color(0xFF9FADBC),  // DarkNeutral1000
    1100: Color(0xFFB6C2CF),  // DarkNeutral1100
    1200: Color(0xFFC7D1DB),  // DarkNeutral1200
    1300: Color(0xFFDEE4EA),  // DarkNeutral1300
  },
);

ThemeData darkTheme = ThemeData(
  fontFamily: 'Inter',
  brightness: Brightness.dark,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: darkMode[1300]!.withValues(alpha: 0.6),
    selectionColor: darkMode[1100]!.withValues(alpha: 0.3),
    selectionHandleColor: darkMode[1100]!.withValues(alpha: 0.8),
  ),
  colorScheme: ColorScheme.dark(
    primaryFixed: darkMode[900]!,
    surface: darkMode[300]!,
    onSurface: darkMode[1300]!,
    primary: darkMode[500]!,
    onPrimary: darkMode[1300]!,
    primaryContainer: Color(0xFF43883D),
    onPrimaryContainer: darkMode[1300]!,
    secondary: darkMode[400]!,
    onSecondary: darkMode[1300]!,
    error: Color(0xFFDA0404),
    onError: darkMode[1300]!,
    errorContainer: darkMode[500]!,
    onErrorContainer: darkMode[1300]!,
    tertiary: darkMode[600]!,
    onTertiary: darkMode[1300]!,
  ),
  
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: darkMode[500]!,
    selectedItemColor: darkMode[1300]!,
    unselectedItemColor: darkMode[1100]!,
    selectedLabelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: darkMode[1300]!),
    unselectedLabelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: darkMode[1100]!),
    selectedIconTheme: IconThemeData(
      size: 32.0,
      color: darkMode[1300]!,
    ),
    unselectedIconTheme: IconThemeData(
      size: 28.0,
      color: darkMode[1100]!.withAlpha(120),
    ),
    elevation: 0,
  ),
);