import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/storage/project_storage.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_dashboard_screen.dart';

final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialMode = await ProjectStorage.getThemeMode();
  themeModeNotifier.value = initialMode;
  runApp(const MyQsApp());
}

class MyQsApp extends StatelessWidget {
  const MyQsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, _) {
        final isDark = currentMode == ThemeMode.dark;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: isDark ? const Color(0xFF0F172A) : AppTheme.headerBlueDark,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: isDark ? const Color(0xFF0D1117) : Colors.white,
            systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          ),
        );
        return MaterialApp(
          title: 'Civil Calculation App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          home: const HomeDashboardScreen(),
        );
      },
    );
  }
}
