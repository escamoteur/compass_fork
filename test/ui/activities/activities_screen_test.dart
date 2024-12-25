// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/activities/_managers/activity_manager_.dart';
import 'package:compass_app/_features/activities/widgets/activities_screen.dart';
import 'package:compass_app/_features/activities/widgets/activity_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:watch_it/watch_it.dart';

import '../../../testing/app.dart';
import '../../../testing/fakes/managers/fake_activities_manager.dart';
import '../../../testing/mocks.dart';

void main() {
  group('ResultsScreen widget tests', () {
    late MockGoRouter goRouter;

    setUp(() {
      di.registerSingleton<ActivityManager>(FakeActivityManager());
      goRouter = MockGoRouter();
    });

    Future<void> loadScreen(WidgetTester tester) async {
      await testApp(
        tester,
        ActivitiesScreen(),
        goRouter: goRouter,
      );
    }

    testWidgets('should load screen', (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await loadScreen(tester);
        expect(find.byType(ActivitiesScreen), findsOneWidget);
      });
    });

    testWidgets('should list activity', (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await loadScreen(tester);
        expect(find.byType(ActivityEntry), findsOneWidget);
        expect(find.text('NAME'), findsOneWidget);
      });
    });

    testWidgets('should select activity and confirm',
        (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await loadScreen(tester);
        // Select one activity
        await tester.tap(find.byKey(const ValueKey('REF-checkbox')));
        expect(di<ActivityManager>().selectedActivities, contains('REF'));

        // Text 1 selected should appear
        await tester.pumpAndSettle();
        expect(find.text('1 selected'), findsOneWidget);

        // Submit selection
        await tester.tap(find.byKey(const ValueKey('confirm-button')));

        // Should navigate to results screen
        verify(() => goRouter.go('/booking')).called(1);
      });
    });
  });
}
