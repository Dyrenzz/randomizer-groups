import 'package:flutter/material.dart';

const MaterialColor lightMode = MaterialColor(
  0xFF8590A2, // Neutral500
  <int, Color>{
    50: Color(0xFFFFFFFF), // Neutral0
    100: Color(0xFFF7F8F9), // Neutral100
    200: Color(0xFFF1F2F4), // Neutral200
    250: Color(0xFFECEEF1), // Neutral250
    300: Color(0xFFDCDFE4), // Neutral300
    400: Color(0xFFB3B9C4), // Neutral400
    500: Color(0xFF8590A2), // Neutral500
    600: Color(0xFF758195), // Neutral600
    700: Color(0xFF626F86), // Neutral700
    800: Color(0xFF44546F), // Neutral800
    900: Color(0xFF2C3E5D), // Neutral900
    1000: Color(0xFF172B4D), // Neutral1000
    1100: Color(0xFF091E42), // Neutral1100
  },
);

ThemeData lightTheme = ThemeData(
  fontFamily: 'Inter',
  brightness: Brightness.light,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: lightMode[1100]!.withValues(alpha: 0.6),
    selectionColor: lightMode[1100]!.withValues(alpha: 0.3),
    selectionHandleColor: lightMode[1100]!.withValues(alpha: 0.8),
  ),
  
  colorScheme: ColorScheme.light(
    primaryFixed: lightMode[900]!,
    surface: lightMode[100]!,
    onSurface: lightMode[1100]!,
    primary: lightMode[300]!,
    onPrimary: lightMode[1100]!,
    primaryContainer: Color(0xFF43883D),
    onPrimaryContainer: Colors.black,
    secondary: lightMode[250]!,
    onSecondary: Colors.black,
    error: Color(0xFFE84646),
    onError: lightMode[100]!,
    errorContainer: lightMode[300]!,
    onErrorContainer: lightMode[1100]!,
    tertiary: lightMode[400]!,
    onTertiary: lightMode[1100]!,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: lightMode[300],
    selectedItemColor: lightMode[1100],
    unselectedItemColor: lightMode[900],
    selectedLabelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: lightMode[1100]),
    unselectedLabelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: lightMode[900]),
    selectedIconTheme: IconThemeData(
      size: 32.0,
      color: lightMode[1100],
    ),
    unselectedIconTheme: IconThemeData(
      size: 28.0,
      color: lightMode[900]!.withAlpha(120),
    ),
    elevation: 0,
  ),
);
