import 'package:flutter/material.dart';

class AppTheme {
  // Exact Civil App Color Palette
  static const Color headerBlue = Color(0xFF1E88E5);        
  static const Color headerBlueDark = Color(0xFF1565C0);  
  static const Color tabIndicatorPink = Color(0xFFE91E63);  
  static const Color cardIceBlue = Color(0xFFEDF3F6);     
  static const Color cardIceBlueBorder = Color(0xFFD6E3EA); 
  static const Color titleBlue = Color(0xFF1565C0);         
  
  // Neutral surfaces
  static const Color scaffoldBg = Color(0xFFF7F9FB);        
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color borderStrong = Color(0xFFCBD5E1);

  // Text Colors
  static const Color textDark = Color(0xFF1E293B);          
  static const Color textMuted = Color(0xFF64748B);         
  static const Color textLight = Color(0xFFFFFFFF);

  // Status & Accents
  static const Color successGreen = Color(0xFF16A34A);
  static const Color warningAmber = Color(0xFFD97706);
  static const Color dangerRed = Color(0xFFDC2626);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: scaffoldBg,
      primaryColor: headerBlue,
      colorScheme: const ColorScheme.light(
        primary: headerBlue,
        onPrimary: Colors.white,
        secondary: tabIndicatorPink,
        onSecondary: Colors.white,
        surface: cardWhite,
        onSurface: textDark,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: headerBlue,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.2,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: cardWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderSubtle, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderStrong),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: headerBlue, width: 2),
        ),
        labelStyle: const TextStyle(color: textMuted, fontSize: 13, fontWeight: FontWeight.w500),
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
        suffixStyle: const TextStyle(color: titleBlue, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: headerBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: headerBlue,
          side: const BorderSide(color: headerBlue, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        indicatorColor: tabIndicatorPink,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Color(0xCCFFFFFF),
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
    );
  }
}
