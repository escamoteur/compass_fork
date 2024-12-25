// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:watch_it/watch_it.dart';

import '../../../_shared/services/api/api_client.dart';
import '../_model/continent.dart';
import 'search_manager_.dart';

/// Remote data source for [Continent].
/// Implements basic local caching.
/// See: https://docs.flutter.dev/get-started/fwe/local-caching
class SearchManagerRemote extends SearchManager {
  SearchManagerRemote({
    ApiClient? apiClient,
  }) : _apiClient = apiClient ?? di.get<ApiClient>();

  final ApiClient _apiClient;

  List<Continent>? _cachedData;

  @override
  Future<List<Continent>> getContinents() async {
    if (_cachedData == null) {
      // No cached data, request continents
      final result = await _apiClient.getContinents();
      _cachedData = result;
      return result;
    } else {
      // Return cached data if available
      return _cachedData!;
    }
  }
}
