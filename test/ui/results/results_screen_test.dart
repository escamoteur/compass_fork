// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/booking/_manager/booking_manager_.dart';
import 'package:compass_app/_features/results/results_screen.dart';
import 'package:compass_app/_shared/itinerary_config/__manager/itinerary_config_manager_.dart';
import 'package:compass_app/_shared/itinerary_config/itinerary_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:watch_it/watch_it.dart';

import '../../../testing/app.dart';
import '../../../testing/fakes/managers/fake_booking_manager.dart';
import '../../../testing/fakes/managers/fake_itinerary_config_manager.dart';
import '../../../testing/mocks.dart';
import '../../../testing/models/booking.dart';

void main() {
  group('ResultsScreen widget tests', () {
    late MockGoRouter goRouter;

    setUp(() {
      final bookingManager = FakeBookingManager()..createBooking(kBooking);
      final itineraryConfigRepository = FakeItineraryConfigManager(
        itineraryConfig: ItineraryConfig(
          continent: 'Europe',
          startDate: DateTime(2024, 01, 01),
          endDate: DateTime(2024, 01, 31),
          guests: 2,
        ),
      );
      di.registerSingleton<ItineraryConfigManager>(itineraryConfigRepository);
      di.registerSingleton<BookingManager>(bookingManager);
      goRouter = MockGoRouter();
    });

    Future<void> loadScreen(WidgetTester tester) async {
      await testApp(
        tester,
        ResultsScreen(),
        goRouter: goRouter,
      );
    }

    testWidgets('should load screen', (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await loadScreen(tester);
        expect(find.byType(ResultsScreen), findsOneWidget);
      });
    });

    testWidgets('should display destination', (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await loadScreen(tester);

        // Wait for list to load
        await tester.pumpAndSettle();

        // Note: Name is converted to uppercase
        expect(find.text('NAME1'), findsOneWidget);
        expect(find.text('tags1'), findsOneWidget);
      });
    });

    testWidgets('should tap and navigate to activities',
        (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await loadScreen(tester);

        // Wait for list to load
        await tester.pumpAndSettle();

        // warnIfMissed false because false negative
        await tester.tap(find.text('NAME1'), warnIfMissed: false);

        verify(() => goRouter.go('/activities')).called(1);
      });
    });
  });
}
