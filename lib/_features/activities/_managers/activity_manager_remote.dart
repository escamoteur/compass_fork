// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:watch_it/watch_it.dart';

import '../../../_shared/services/api/api_client.dart';
import '../_model/activity.dart';
import 'activity_manager_.dart';

/// Remote data source for [Activity].
/// Implements basic local caching.
/// See: https://docs.flutter.dev/get-started/fwe/local-caching
class ActivitManagerRemote extends ActivityManager {
  ActivitManagerRemote({
    ApiClient? apiClient,
  }) : _apiClient = apiClient ?? di.get<ApiClient>();

  final ApiClient _apiClient;

  final Map<String, List<Activity>> _cachedData = {};

  @override
  Future<List<Activity>> getByDestination(String ref) async {
    if (!_cachedData.containsKey(ref)) {
      // No cached data, request activities
      final result = await _apiClient.getActivityByDestination(ref);
      _cachedData[ref] = result;
      return result;
    } else {
      // Return cached data if available
      return _cachedData[ref]!;
    }
  }
}
