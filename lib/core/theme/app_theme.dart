import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Palette
  static const Color headerBlue = Color(0xFF1E88E5);
  static const Color headerBlueDark = Color(0xFF1565C0);
  static const Color tabIndicatorPink = Color(0xFFE91E63);
  static const Color cardIceBlue = Color(0xFFEDF3F6);
  static const Color cardIceBlueBorder = Color(0xFFD6E3EA);
  static const Color titleBlue = Color(0xFF1565C0);

  // Neutral surfaces (Light)
  static const Color scaffoldBg = Color(0xFFF7F9FB);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color borderStrong = Color(0xFFCBD5E1);

  // Text Colors (Light)
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textLight = Color(0xFFFFFFFF);

  // Status & Accents
  static const Color successGreen = Color(0xFF16A34A);
  static const Color warningAmber = Color(0xFFD97706);
  static const Color dangerRed = Color(0xFFDC2626);

  // Dark Theme Palette (Client Default: Sleek Black / Dark Mode)
  static const Color darkScaffoldBg = Color(0xFF0F141C);
  static const Color darkCardBg = Color(0xFF181F2C);
  static const Color darkCardIceBlue = Color(0xFF1B2636);
  static const Color darkCardIceBlueBorder = Color(0xFF2A3A52);
  static const Color darkBorderSubtle = Color(0xFF253041);
  static const Color darkBorderStrong = Color(0xFF33435C);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkAccentBlue = Color(0xFF60A5FA);

  // Context-aware color helpers
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color scaffoldColor(BuildContext context) =>
      isDark(context) ? darkScaffoldBg : scaffoldBg;

  static Color cardBg(BuildContext context) =>
      isDark(context) ? darkCardBg : cardWhite;

  static Color iceCardBg(BuildContext context) =>
      isDark(context) ? darkCardIceBlue : cardIceBlue;

  static Color iceCardBorder(BuildContext context) =>
      isDark(context) ? darkCardIceBlueBorder : cardIceBlueBorder;

  static Color borderSubtleColor(BuildContext context) =>
      isDark(context) ? darkBorderSubtle : borderSubtle;

  static Color borderStrongColor(BuildContext context) =>
      isDark(context) ? darkBorderStrong : borderStrong;

  static Color textPrimary(BuildContext context) =>
      isDark(context) ? darkTextPrimary : textDark;

  static Color textSecondary(BuildContext context) =>
      isDark(context) ? darkTextSecondary : textMuted;

  static Color accentBlue(BuildContext context) =>
      isDark(context) ? darkAccentBlue : titleBlue;

  static Color subtleBoxBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF121822) : const Color(0xFFF8FAFC);

  static Color chipUnselectedBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF1B2433) : Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: scaffoldBg,
      primaryColor: headerBlue,
      cardColor: cardWhite,
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
      dialogTheme: const DialogThemeData(
        backgroundColor: cardWhite,
        titleTextStyle: TextStyle(color: textDark, fontSize: 18, fontWeight: FontWeight.bold),
        contentTextStyle: TextStyle(color: textMuted, fontSize: 14),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: cardWhite,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkScaffoldBg,
      primaryColor: headerBlue,
      cardColor: darkCardBg,
      colorScheme: const ColorScheme.dark(
        primary: headerBlue,
        onPrimary: Colors.white,
        secondary: tabIndicatorPink,
        onSecondary: Colors.white,
        surface: darkCardBg,
        onSurface: darkTextPrimary,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F172A),
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
        color: darkCardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: darkBorderSubtle, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF131923),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: darkBorderStrong),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: darkBorderStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: darkAccentBlue, width: 2),
        ),
        labelStyle: const TextStyle(color: darkTextSecondary, fontSize: 13, fontWeight: FontWeight.w500),
        hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
        suffixStyle: const TextStyle(color: darkAccentBlue, fontWeight: FontWeight.bold),
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
          foregroundColor: darkAccentBlue,
          side: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
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
      dialogTheme: const DialogThemeData(
        backgroundColor: darkCardBg,
        titleTextStyle: TextStyle(color: darkTextPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        contentTextStyle: TextStyle(color: darkTextSecondary, fontSize: 14),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: darkCardBg,
      ),
    );
  }
}
