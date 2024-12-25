// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/booking/_manager/booking_manager_local.dart';
import 'package:compass_app/_shared/services/local/local_data_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DestinationRepositoryLocal tests', () {
    // To load assets
    TestWidgetsFlutterBinding.ensureInitialized();

    final repository = BookingManagerLocal(
      localDataService: LocalDataService(),
    );

    test('should load and parse', () async {
      // Should load the json and parse it
      final result = await repository.getDestinations();

      // Check that the list is complete
      expect(result.length, 137);

      // Check first item
      final destination = result.first;
      expect(destination.name, 'Alaska');
    });
  });
}
