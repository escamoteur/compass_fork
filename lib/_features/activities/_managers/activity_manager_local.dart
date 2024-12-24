// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../../../_shared/services/local/local_data_service.dart';
import '../_model/activity.dart';
import 'activity_manager_.dart';

/// Local implementation of ActivityRepository
/// Uses data from assets folder
class ActivityManagerLocal extends ActivityManager {
  ActivityManagerLocal({
    required LocalDataService localDataService,
  }) : _localDataService = localDataService;

  final LocalDataService _localDataService;

  @override
  Future<List<Activity>> getByDestination(String ref) async {
    final activities = (await _localDataService.getActivities())
        .where((activity) => activity.destinationRef == ref)
        .toList();

    return activities;
  }
}
