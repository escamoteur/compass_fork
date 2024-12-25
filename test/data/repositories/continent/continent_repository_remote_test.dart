// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/search/_manager/search_manager_.dart';
import 'package:compass_app/_features/search/_manager/search_manager_remote.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../testing/fakes/services/fake_api_client.dart';

void main() {
  group('ContinentRepositoryRemote tests', () {
    late FakeApiClient apiClient;
    late SearchManager repository;

    setUp(() {
      apiClient = FakeApiClient();
      repository = SearchManagerRemote(apiClient: apiClient);
    });

    test('should get continents', () async {
      final result = await repository.getContinents();
      expect(result.length, 3);

      final destination = result.first;
      expect(destination.name, 'CONTINENT');

      // Only one request happened
      expect(apiClient.requestCount, 1);
    });

    test('should get continents from cache', () async {
      // Request continents once
      var result = await repository.getContinents();

      // Request continents another time
      result = await repository.getContinents();
      expect(result.length, 3);

      // Only one request happened
      expect(apiClient.requestCount, 1);
    });
  });
}
