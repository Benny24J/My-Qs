import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_qs/core/models/project_model.dart';
import 'package:my_qs/core/theme/app_theme.dart';
import 'package:my_qs/features/projects/project_summary_screen.dart';
import 'package:my_qs/features/quick_calc/blocks_calc_screen.dart';
import 'package:my_qs/features/quick_calc/concrete_calc_screen.dart';
import 'package:my_qs/features/settings/settings_screen.dart';
import 'package:my_qs/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Theme default is Dark and can toggle to Light', (WidgetTester tester) async {
    themeModeNotifier.value = ThemeMode.dark;
    await tester.pumpWidget(const MyQsApp());
    await tester.pumpAndSettle();

    // Verify app rendered in dark theme
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);

    // Tap theme toggle button in AppBar
    final toggleButton = find.byTooltip('Switch to Light Mode');
    expect(toggleButton, findsOneWidget);
    await tester.tap(toggleButton);
    await tester.pumpAndSettle();

    // Verify theme changed to Light
    expect(themeModeNotifier.value, ThemeMode.light);
  });

  testWidgets('Small device (320x568) - Home dashboard renders without pixel overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    themeModeNotifier.value = ThemeMode.dark;
    await tester.pumpWidget(const MyQsApp());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Tiles'), findsOneWidget);
    expect(find.text('Wall Blocks'), findsOneWidget);
  });

  testWidgets('Small device (320x568) - Concrete calc screen renders without pixel overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const ConcreteCalcScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Concrete Batching Calculator'), findsOneWidget);
    expect(find.text('Materials to Buy (Cement, Sand & Granite)'), findsOneWidget);
  });

  testWidgets('Small device (320x568) - Wall blocks calc screen renders without pixel overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const BlocksCalcScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Wall Blocks & Mortar'), findsOneWidget);
  });

  testWidgets('Small device (320x568) - Project summary screen metrics do not overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final testProject = ProjectModel(
      id: 'test-1',
      name: 'Duplex Villa Lekki',
      clientName: 'Alhaji Musa',
      location: 'Phase 1 Lekki',
      createdAt: DateTime.now(),
      wastagePercent: 5.0,
      rooms: [
        RoomModel(id: 'r1', name: 'Master Bed', length: 5.0, width: 4.0, height: 3.0),
        RoomModel(id: 'r2', name: 'Living Room', length: 6.5, width: 5.0, height: 3.0),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: ProjectSummaryScreen(project: testProject),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Duplex Villa Lekki'), findsOneWidget);
    expect(find.textContaining('Master Material Purchasing List'), findsOneWidget);
  });

  testWidgets('Settings screen allows selecting Light theme and Dark theme', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const SettingsScreen(),
      ),
    );
    // Pump past the async storage load
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('App Theme & Appearance'), findsOneWidget);
    expect(find.text('Dark (Default)'), findsOneWidget);
    expect(find.text('Light Mode'), findsOneWidget);

    await tester.tap(find.text('Light Mode'));
    await tester.pumpAndSettle();
    expect(themeModeNotifier.value, ThemeMode.light);
  });
}
