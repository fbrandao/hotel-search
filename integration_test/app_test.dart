import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hotel_booking/main.dart' as app;
import 'package:hotel_booking/features/hotels/presentation/widgets/hotel_card.dart';
import 'test_utils.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => PathProviderPlatform.instance = TestPathProviderPlatform());
  tearDownAll(() => TestPathProviderPlatform.cleanUp());

  testWidgets('Search for hotels', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Search for hotels
    await tester.tap(find.byIcon(Icons.hotel_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Paris');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify search results
    expect(find.byType(HotelCard), findsWidgets);
  });
} 