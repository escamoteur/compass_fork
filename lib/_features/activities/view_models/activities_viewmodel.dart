// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../_shared/itinerary_config/__manager/itinerary_config_manager_.dart';
import '../../../_shared/utils/command.dart';
import '../../../_shared/utils/result.dart';
import '../_model/activity.dart';
import '../_repo/activity_repository.dart';

class ActivitiesViewModel extends ChangeNotifier {
  ActivitiesViewModel({
    required ActivityRepository activityRepository,
    required ItineraryConfigManager itineraryConfigRepository,
  })  : _activityRepository = activityRepository,
        _itineraryConfigRepository = itineraryConfigRepository {
    loadActivities = Command0(_loadActivities)..execute();
    saveActivities = Command0(_saveActivities);
  }

  final _log = Logger('ActivitiesViewModel');
  final ActivityRepository _activityRepository;
  final ItineraryConfigManager _itineraryConfigRepository;
  List<Activity> _daytimeActivities = <Activity>[];
  List<Activity> _eveningActivities = <Activity>[];
  final Set<String> _selectedActivities = <String>{};

  /// List of daytime [Activity] per destination.
  List<Activity> get daytimeActivities => _daytimeActivities;

  /// List of evening [Activity] per destination.
  List<Activity> get eveningActivities => _eveningActivities;

  /// Selected [Activity] by ref.
  Set<String> get selectedActivities => _selectedActivities;

  /// Load list of [Activity] for a [Destination] by ref.
  late final Command0 loadActivities;

  /// Save list [selectedActivities] into itinerary configuration.
  late final Command0 saveActivities;

  Future<void> _loadActivities() async {
    final result = await _itineraryConfigRepository.getItineraryConfig();
    if (result is Error) {
      _log.warning(
        'Failed to load stored ItineraryConfig',
        result.asError.error,
      );
      return result;
    }

    final destinationRef = result.destination;
    if (destinationRef == null) {
      _log.severe('Destination missing in ItineraryConfig');
      return Result.error(Exception('Destination not found'));
    }

    _selectedActivities.addAll(result.activities);

    final resultActivities =
        await _activityRepository.getByDestination(destinationRef);
    switch (resultActivities) {
      case Ok():
        {
          _daytimeActivities = resultActivities.value
              .where((activity) => [
                    TimeOfDay.any,
                    TimeOfDay.morning,
                    TimeOfDay.afternoon,
                  ].contains(activity.timeOfDay))
              .toList();

          _eveningActivities = resultActivities.value
              .where((activity) => [
                    TimeOfDay.evening,
                    TimeOfDay.night,
                  ].contains(activity.timeOfDay))
              .toList();

          _log.fine('Activities (daytime: ${_daytimeActivities.length}, '
              'evening: ${_eveningActivities.length}) loaded');
        }
      case Error():
        {
          _log.warning('Failed to load activities', resultActivities.error);
        }
    }

    notifyListeners();
    return resultActivities;
  }

  /// Add [Activity] to selected list.
  void addActivity(String activityRef) {
    assert(
      (_daytimeActivities + _eveningActivities)
          .any((activity) => activity.ref == activityRef),
      "Activity $activityRef not found",
    );
    _selectedActivities.add(activityRef);
    _log.finest('Activity $activityRef added');
    notifyListeners();
  }

  /// Remove [Activity] from selected list.
  void removeActivity(String activityRef) {
    assert(
      (_daytimeActivities + _eveningActivities)
          .any((activity) => activity.ref == activityRef),
      "Activity $activityRef not found",
    );
    _selectedActivities.remove(activityRef);
    _log.finest('Activity $activityRef removed');
    notifyListeners();
  }

  Future<void> _saveActivities() async {
    final resultConfig = await _itineraryConfigRepository.getItineraryConfig();
    if (resultConfig is Error) {
      _log.warning(
        'Failed to load stored ItineraryConfig',
        resultConfig.asError.error,
      );
      return resultConfig;
    }

    final itineraryConfig = resultConfig;
    final result = await _itineraryConfigRepository.setItineraryConfig(
        itineraryConfig.copyWith(activities: _selectedActivities.toList()));
    if (result is Error) {
      _log.warning(
        'Failed to store ItineraryConfig',
        result.asError.error,
      );
    }
    return result;
  }
}
