// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../../../_shared/services/api/api_client.dart';
import '../../../_shared/utils/result.dart';
import '../_model/activity.dart';
import 'activity_repository.dart';

/// Remote data source for [Activity].
/// Implements basic local caching.
/// See: https://docs.flutter.dev/get-started/fwe/local-caching
class ActivityRepositoryRemote implements ActivityRepository {
  ActivityRepositoryRemote({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  final Map<String, List<Activity>> _cachedData = {};

  @override
  Future<List<Activity>> getByDestination(String ref) async {
    if (!_cachedData.containsKey(ref)) {
      // No cached data, request activities
      final result = await _apiClient.getActivityByDestination(ref);
      if (result is Ok) {
        _cachedData[ref] = result;
      }
      return result;
    } else {
      // Return cached data if available
      return Result.ok(_cachedData[ref]!);
    }
  }
}
