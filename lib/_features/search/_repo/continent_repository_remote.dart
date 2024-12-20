// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../../../_shared/services/api/api_client.dart';
import '../../../_shared/utils/result.dart';
import '../_model/continent.dart';
import 'continent_repository.dart';

/// Remote data source for [Continent].
/// Implements basic local caching.
/// See: https://docs.flutter.dev/get-started/fwe/local-caching
class ContinentRepositoryRemote implements ContinentRepository {
  ContinentRepositoryRemote({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  List<Continent>? _cachedData;

  @override
  Future<List<Continent>> getContinents() async {
    if (_cachedData == null) {
      // No cached data, request continents
      final result = await _apiClient.getContinents();
      if (result is Ok) {
        // Store value if result Ok
        _cachedData = result;
      }
      return result;
    } else {
      // Return cached data if available
      return Result.ok(_cachedData!);
    }
  }
}
