// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/search/_manager/search_manager_.dart';
import 'package:compass_app/_features/search/widgets/search_form_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '../../../../testing/app.dart';
import '../../../../testing/fakes/managers/fake_search_manager.dart';

void main() {
  group('SearchFormDate widget tests', () {
    late FakeSearchManager searchManager;

    setUp(() {
      searchManager = FakeSearchManager();
      di.registerSingleton<SearchManager>(searchManager);
    });

    loadWidget(WidgetTester tester) async {
      await testApp(tester, SearchFormDate());
    }

    testWidgets('should display date in different month',
        (WidgetTester tester) async {
      await loadWidget(tester);
      expect(find.byType(SearchFormDate), findsOneWidget);

      // Initial state
      expect(find.text('Add Dates'), findsOneWidget);

      // Simulate date picker input:
      searchManager.dateRange = DateTimeRange(
          start: DateTime(2024, 6, 12), end: DateTime(2024, 7, 23));
      await tester.pumpAndSettle();

      expect(find.text('12 Jun - 23 Jul'), findsOneWidget);
    });

    testWidgets('should display date in same month',
        (WidgetTester tester) async {
      await loadWidget(tester);
      expect(find.byType(SearchFormDate), findsOneWidget);

      // Initial state
      expect(find.text('Add Dates'), findsOneWidget);

      // Simulate date picker input:
      searchManager.dateRange = DateTimeRange(
          start: DateTime(2024, 6, 12), end: DateTime(2024, 6, 23));
      await tester.pumpAndSettle();

      expect(find.text('12 - 23 Jun'), findsOneWidget);
    });
  });
}
