// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/booking/_manager/booking_manager_remote.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../testing/fakes/services/fake_api_client.dart';

void main() {
  group('DestinationRepositoryRemote tests', () {
    late FakeApiClient apiClient;
    late BookingManagerRemote repository;

    setUp(() {
      apiClient = FakeApiClient();
      repository = BookingManagerRemote(apiClient: apiClient);
    });

    test('should get destinations', () async {
      final result = await repository.getDestinations();
      expect(result.length, 2);

      final destination = result.first;
      expect(destination.name, 'name1');

      // Only one request happened
      expect(apiClient.requestCount, 1);
    });

    test('should get destinations from cache', () async {
      // Request destination once
      var result = await repository.getDestinations();
      expect(result.length, 2);

      // Request destination another time
      result = await repository.getDestinations();
      expect(result.length, 2);

      // Only one request happened
      expect(apiClient.requestCount, 1);
    });
  });
}
