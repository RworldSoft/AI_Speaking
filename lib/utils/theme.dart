import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Global theme configuration for the BetterSpeak app.
/// 
/// Uses a White and Deep Blue (#3A41D8) color palette.
/// Typography is powered by GoogleFonts.inter.
class AppTheme {
  // Custom Deep Blue color
  static const Color primaryBlue = Color(0xFF3A41D8);
  static const Color surfaceWhite = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        onPrimary: Colors.white,
        surface: surfaceWhite,
        onSurface: primaryBlue,
      ),
      scaffoldBackgroundColor: surfaceWhite,
      
      // Setting Inter as the default text theme
      textTheme: GoogleFonts.interTextTheme(),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceWhite,
        foregroundColor: primaryBlue,
        elevation: 0,
        centerTitle: true,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
