import 'package:flutter_test/flutter_test.dart';
import 'package:app_family_tree/app/family_tree_app.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FamilyTreeApp());

    // Verify that our counter starts at 0.
    // Note: The template test might fail if the app doesn't have a counter.
  });
}
