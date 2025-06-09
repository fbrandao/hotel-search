import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/features/hotels/presentation/widgets/hotel_card.dart';
import 'package:hotel_booking/features/hotels/domain/entities/entities.dart';

void main() {
  testWidgets('HotelCard displays hotel information correctly', (tester) async {
    bool isFavorite = false;
    final hotel = Hotel(
      name: 'Test Hotel',
      location: const Location(
        latitude: 48.8566,
        longitude: 2.3522,
      ),
      description: 'A beautiful hotel in Paris',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HotelCard(
            hotel: hotel,
            isFavorite: isFavorite,
            onFavoriteChanged: (value) {
              isFavorite = value;
            },
          ),
        ),
      ),
    );

    // Verify hotel information is displayed
    expect(find.text('Test Hotel'), findsOneWidget);
    expect(find.text('A beautiful hotel in Paris'), findsOneWidget);

    // Verify favorite button is present and shows outline icon
    expect(find.byIcon(Icons.favorite_outline), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNothing);

    // Tap favorite button
    await tester.tap(find.byIcon(Icons.favorite_outline));
    await tester.pump();

    // Rebuild widget with new favorite state
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HotelCard(
            hotel: hotel,
            isFavorite: isFavorite,
            onFavoriteChanged: (value) {
              isFavorite = value;
            },
          ),
        ),
      ),
    );

    // Verify favorite button shows filled icon
    expect(find.byIcon(Icons.favorite_outline), findsNothing);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
} 