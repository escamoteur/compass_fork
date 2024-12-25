// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/activities/_managers/activity_manager_.dart';
import 'package:compass_app/_features/activities/_managers/activity_manager_remote.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../testing/fakes/services/fake_api_client.dart';

void main() {
  group('ActivityRepositoryRemote tests', () {
    late FakeApiClient apiClient;
    late ActivityManager repository;

    setUp(() {
      apiClient = FakeApiClient();
      repository = ActivitManagerRemote(apiClient: apiClient);
    });

    test('should get activities for destination', () async {
      final result = await repository.getByDestination('alaska');

      expect(result.length, 1);

      final destination = result.first;
      expect(destination.name, 'Glacier Trekking and Ice Climbing');

      // Only one request happened
      expect(apiClient.requestCount, 1);
    });

    test('should get destinations from cache', () async {
      // Request destination once
      // ignore: unused_local_variable
      var result = await repository.getByDestination('alaska');

      // Request destination another time
      result = await repository.getByDestination('alaska');

      // Only one request happened
      expect(apiClient.requestCount, 1);
    });
  });
}
