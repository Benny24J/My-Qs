import 'package:flutter_test/flutter_test.dart';
import 'package:my_qs/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyQsApp());
    expect(find.text('Civil Calculation App'), findsWidgets);
  });
}
