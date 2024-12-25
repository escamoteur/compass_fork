// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/search/_manager/search_manager_.dart';
import 'package:compass_app/_features/search/widgets/search_form_guests.dart';
import 'package:compass_app/_features/search/widgets/search_form_screen.dart';
import 'package:compass_app/_features/search/widgets/search_form_submit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watch_it/watch_it.dart';
import '../../../../testing/app.dart';
import '../../../../testing/fakes/managers/fake_search_manager.dart';
import '../../../../testing/mocks.dart';

void main() {
  group('SearchFormScreen widget tests', () {
    late FakeSearchManager searchManager;
    late MockGoRouter goRouter;

    setUp(() {
      searchManager = FakeSearchManager();
      di.registerSingleton<SearchManager>(searchManager);
      goRouter = MockGoRouter();
    });

    loadWidget(WidgetTester tester) async {
      await testApp(
        tester,
        SearchFormScreen(),
        goRouter: goRouter,
      );
    }

    testWidgets('Should fill form and perform search',
        (WidgetTester tester) async {
      await loadWidget(tester);
      expect(find.byType(SearchFormScreen), findsOneWidget);

      // Select continent
      await tester.tap(find.text('CONTINENT'), warnIfMissed: false);

      // Select date
      searchManager.dateRange = DateTimeRange(
          start: DateTime(2024, 6, 12), end: DateTime(2024, 7, 23));

      // Select guests
      await tester.tap(find.byKey(const ValueKey(addGuestsKey)));

      // Refresh screen state
      await tester.pumpAndSettle();

      // Perform search
      await tester.tap(find.byKey(const ValueKey(searchFormSubmitButtonKey)));

      // Should navigate to results screen
      verify(() => goRouter.go('/results')).called(1);
    });
  });
}
