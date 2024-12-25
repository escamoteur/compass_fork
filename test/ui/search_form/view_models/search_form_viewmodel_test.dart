// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../testing/fakes/managers/fake_search_manager.dart';

void main() {
  group('SearchFormViewModel Tests', () {
    late FakeSearchManager searchManager;

    setUp(() {
      searchManager = FakeSearchManager();
    });

    test('Initial values are correct', () {
      expect(searchManager.valid, false);
      expect(searchManager.selectedContinent, null);
      expect(searchManager.dateRange, null);
      expect(searchManager.guests, 0);
    });

    test('Setting dateRange updates correctly', () {
      final DateTimeRange newDateRange = DateTimeRange(
        start: DateTime(2024, 1, 1),
        end: DateTime(2024, 1, 31),
      );
      searchManager.dateRange = newDateRange;
      expect(searchManager.dateRange, newDateRange);
    });

    test('Setting selectedContinent updates correctly', () {
      searchManager.selectedContinent = 'CONTINENT';
      expect(searchManager.selectedContinent, 'CONTINENT');

      // Setting null should work
      searchManager.selectedContinent = null;
      expect(searchManager.selectedContinent, null);
    });

    test('Setting guests updates correctly', () {
      searchManager.guests = 2;
      expect(searchManager.guests, 2);

      // Guests number should not be negative
      searchManager.guests = -1;
      expect(searchManager.guests, 0);
    });

    test('Set all values and save', () async {
      expect(searchManager.valid, false);

      searchManager.guests = 2;
      searchManager.selectedContinent = 'CONTINENT';
      final DateTimeRange newDateRange = DateTimeRange(
        start: DateTime(2024, 1, 1),
        end: DateTime(2024, 1, 31),
      );
      searchManager.dateRange = newDateRange;

      expect(searchManager.valid, true);
      final future =
          searchManager.updateItineraryConfigCommand.executeWithFuture();
      expect(future, completes);
    });
  });
}
