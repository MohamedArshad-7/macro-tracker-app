import 'package:flutter_test/flutter_test.dart';
import 'package:macro_tracker/main.dart';

void main() {
  testWidgets('MacroTrackerApp renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MacroTrackerApp());

    expect(find.byType(MacroTrackerApp), findsOneWidget);
  });
}
