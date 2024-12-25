// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/booking/_manager/booking_manager_.dart';
import 'package:compass_app/_shared/itinerary_config/__manager/itinerary_config_manager_.dart';
import 'package:compass_app/_shared/itinerary_config/itinerary_config.dart';
import 'package:compass_app/_features/booking/widgets/booking_screen.dart';
import 'package:compass_app/_shared/services/share_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '../../../testing/app.dart';
// ignore: unused_import
import '../../../testing/fakes/managers/fake_activities_manager.dart';
import '../../../testing/fakes/managers/fake_booking_manager.dart';
import '../../../testing/fakes/managers/fake_itinerary_config_manager.dart';
import '../../../testing/mocks.dart';
import '../../../testing/models/activity.dart';
import '../../../testing/models/booking.dart';
import '../../../testing/models/destination.dart';

void main() {
  group('BookingScreen widget tests', () {
    late MockGoRouter goRouter;
    late FakeBookingManager bookingManager;
    late bool shared;

    setUp(() {
      shared = false;
      bookingManager = FakeBookingManager();
      di.registerSingleton<BookingManager>(bookingManager);
      di.registerSingleton<ItineraryConfigManager>(
        FakeItineraryConfigManager(
          itineraryConfig: ItineraryConfig(
            continent: 'Europe',
            startDate: DateTime(2024, 01, 01),
            endDate: DateTime(2024, 01, 31),
            guests: 2,
            destination: kDestination1.ref,
            activities: [kActivity.ref],
          ),
        ),
      );
      di.registerSingleton<ShareService>(ShareService.custom((text) async {
        shared = true;
      }));
      goRouter = MockGoRouter();
    });

    Future<void> loadScreen(WidgetTester tester) async {
      await testApp(
        tester,
        BookingScreen(),
        goRouter: goRouter,
      );
    }

    testWidgets('should load screen', (WidgetTester tester) async {
      await loadScreen(tester);
      expect(find.byType(BookingScreen), findsOneWidget);
    });

    testWidgets('should display booking from ID', (WidgetTester tester) async {
      // Add a booking to repository
      bookingManager.createBooking(kBooking);

      // Load screen
      await loadScreen(tester);

      // Load booking with ID 0
      bookingManager.loadBookingCommand(0);

      // Wait for booking to load
      await tester.pumpAndSettle();

      expect(find.text(kBooking.destination.name), findsOneWidget);
      expect(find.text(kBooking.destination.tags.first), findsOneWidget);
    });

    testWidgets('should create booking from itinerary config',
        (WidgetTester tester) async {
      await loadScreen(tester);

      // Create a new booking from stored itinerary config
      bookingManager.createBookingCommand();

      // Wait for booking to load
      await tester.pumpAndSettle();

      expect(find.text('name1'), findsOneWidget);
      expect(find.text('tags1'), findsOneWidget);

      // Booking is saved
      expect(bookingManager.bookings.length, 1);
    });

    testWidgets('should share booking', (WidgetTester tester) async {
      bookingManager.createBooking(kBooking);
      await loadScreen(tester);
      bookingManager.loadBookingCommand(0);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('share-button')));
      expect(shared, true);
    });
  });
}
