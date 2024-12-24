// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:logging/logging.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/itinerary_config/__manager/itinerary_config_manager_.dart';
import '../_model/activity.dart';

/// Data source for activities.
abstract class ActivityManager extends ChangeNotifier {
  List<Activity> _daytimeActivities = <Activity>[];
  List<Activity> _eveningActivities = <Activity>[];

  /// List of daytime [Activity] per destination.
  List<Activity> get daytimeActivities => _daytimeActivities;

  /// List of evening [Activity] per destination.
  List<Activity> get eveningActivities => _eveningActivities;
  final Set<String> _selectedActivities = <String>{};

  /// Selected [Activity] by ref.
  Set<String> get selectedActivities => _selectedActivities;
  final _log = Logger('ActivityManager');

  late final Command<void, void> loadActivitiesCommand =
      Command.createAsyncNoParamNoResult(() async {
    final result = await di<ItineraryConfigManager>().getItineraryConfig();

    final destinationRef = result.destination;
    if (destinationRef == null) {
      _log.severe('Destination missing in ItineraryConfig');
      throw Exception('Destination not found');
    }

    final resultActivities = await getByDestination(destinationRef);
    _daytimeActivities = resultActivities
        .where((activity) => [
              TimeOfDay.any,
              TimeOfDay.morning,
              TimeOfDay.afternoon,
            ].contains(activity.timeOfDay))
        .toList();

    _eveningActivities = resultActivities
        .where((activity) => [
              TimeOfDay.evening,
              TimeOfDay.night,
            ].contains(activity.timeOfDay))
        .toList();

    _log.fine('Activities (daytime: ${_daytimeActivities.length}, '
        'evening: ${_eveningActivities.length}) loaded');

    notifyListeners();
  });

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

  late final Command<void, void> saveActivitiesCommand =
      Command.createAsyncNoParamNoResult(() async {
    final resultConfig =
        await di<ItineraryConfigManager>().getItineraryConfig();

    final itineraryConfig = resultConfig;
    await di<ItineraryConfigManager>().setItineraryConfig(
        itineraryConfig.copyWith(activities: _selectedActivities.toList()));
  });

  /// Get activities by [Destination] ref.
  Future<List<Activity>> getByDestination(String ref);
}
