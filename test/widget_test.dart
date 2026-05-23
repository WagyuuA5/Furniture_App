import 'package:flutter_test/flutter_test.dart';
import 'package:app_furniture/main.dart';

void main() {
  testWidgets('App should render without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const FurnitureApp());
    // Verify app title is rendered
    expect(find.text('LUXE FURNISH'), findsAny);
  });
}
