// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/auth/_managers/auth_manager_.dart';
import 'package:compass_app/_features/auth/logout/widgets/logout_button.dart';
import 'package:compass_app/_shared/itinerary_config/itinerary_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:watch_it/watch_it.dart';

import '../../../testing/app.dart';
import '../../../testing/fakes/managers/fake_auth_manager.dart';
import '../../../testing/fakes/managers/fake_itinerary_config_manager.dart';
import '../../../testing/mocks.dart';

void main() {
  group('LogoutButton test', () {
    late MockGoRouter goRouter;
    late FakeAuthManager fakeAuthRepository;
    late FakeItineraryConfigManager fakeItineraryConfigRepository;

    setUp(() {
      goRouter = MockGoRouter();
      fakeAuthRepository = FakeAuthManager();
      // Setup a token, should be cleared after logout
      fakeAuthRepository.token = 'TOKEN';
      // Setup an ItineraryConfig with some data, should be cleared after logout
      fakeItineraryConfigRepository = FakeItineraryConfigManager(
          itineraryConfig: const ItineraryConfig(continent: 'CONTINENT'));
      di.registerSingleton<AuthManager>(fakeAuthRepository);
    });

    Future<void> loadScreen(WidgetTester tester) async {
      await testApp(
        tester,
        LogoutButton(),
        goRouter: goRouter,
      );
    }

    testWidgets('should load widget', (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await loadScreen(tester);
        expect(find.byType(LogoutButton), findsOneWidget);
      });
    });

    testWidgets('should perform logout', (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await loadScreen(tester);

        // Repo should have a key
        expect(fakeAuthRepository.token, 'TOKEN');
        // Itinerary config should have data
        expect(
          fakeItineraryConfigRepository.itineraryConfig,
          const ItineraryConfig(continent: 'CONTINENT'),
        );

        // // Perform logout
        await tester.tap(find.byType(LogoutButton));
        await tester.pumpAndSettle();

        // Repo should have no key
        expect(fakeAuthRepository.token, null);
        // Itinerary config should be cleared
        expect(
          fakeItineraryConfigRepository.itineraryConfig,
          const ItineraryConfig(),
        );
      });
    });
  });
}
