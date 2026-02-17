import 'package:flutter/material.dart';

/// Light Mode Neutral Palette
const MaterialColor lightMode = MaterialColor(
  0xFF8590A2, // Neutral500
  <int, Color>{
    50: Color(0xFFFFFFFF),    // Neutral0
    100: Color(0xFFF7F8F9),   // Neutral100
    200: Color(0xFFF1F2F4),   // Neutral200
    300: Color(0xFFDCDFE4),   // Neutral300
    400: Color(0xFFB3B9C4),   // Neutral400
    500: Color(0xFF8590A2),   // Neutral500
    600: Color(0xFF758195),   // Neutral600
    700: Color(0xFF626F86),   // Neutral700
    800: Color(0xFF44546F),   // Neutral800
    900: Color(0xFF2C3E5D),   // Neutral900
    1000: Color(0xFF172B4D),  // Neutral1000
    1100: Color(0xFF091E42),  // Neutral1100
  },
);

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

class AcccentColors {
  static const Color sunColor = Color(0xFFD3A900);
  static const Color moonColor = Color(0xFF5E65AF);
}