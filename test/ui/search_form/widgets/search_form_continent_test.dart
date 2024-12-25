// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/search/_manager/search_manager_.dart';
import 'package:compass_app/_features/search/widgets/search_form_continent.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '../../../../testing/app.dart';
import '../../../../testing/fakes/managers/fake_search_manager.dart';

void main() {
  group('SearchFormContinent widget tests', () {
    late FakeSearchManager searchManager;

    setUp(() {
      searchManager = FakeSearchManager();
      di.registerSingleton<SearchManager>(searchManager);
    });

    loadWidget(WidgetTester tester) async {
      await testApp(tester, SearchFormContinent());
    }

    testWidgets('Should load and select continent',
        (WidgetTester tester) async {
      await loadWidget(tester);
      expect(find.byType(SearchFormContinent), findsOneWidget);

      // Select continent
      await tester.tap(find.text('CONTINENT'), warnIfMissed: false);

      expect(searchManager.selectedContinent, 'CONTINENT');
    });
  });
}
