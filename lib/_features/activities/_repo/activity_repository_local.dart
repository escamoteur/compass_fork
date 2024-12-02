// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../_model/activity.dart';
import '../../../_shared/utils/result.dart';
import '../../../_shared/services/local/local_data_service.dart';
import 'activity_repository.dart';

/// Local implementation of ActivityRepository
/// Uses data from assets folder
class ActivityRepositoryLocal implements ActivityRepository {
  ActivityRepositoryLocal({
    required LocalDataService localDataService,
  }) : _localDataService = localDataService;

  final LocalDataService _localDataService;

  @override
  Future<List<Activity>>> getByDestination(String ref) async {
    try {
      final activities = (await _localDataService.getActivities())
          .where((activity) => activity.destinationRef == ref)
          .toList();

      return Result.ok(activities);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
