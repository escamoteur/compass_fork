// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:logging/logging.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/itinerary_config/__manager/itinerary_config_manager_.dart';
import '../_model/continent.dart';

/// Data source with all possible continents.
abstract class SearchManager extends ChangeNotifier {
  /// Get complete list of continents.
  Future<List<Continent>> getContinents();

  final _log = Logger('SearchManager');
  List<Continent> _continents = [];
  String? _selectedContinent;
  DateTimeRange? _dateRange;
  int _guests = 0;

  /// True if the form is valid and can be submitted
  bool get valid =>
      _guests > 0 && _selectedContinent != null && _dateRange != null;

  /// List of continents.
  /// Loaded in [load] command.
  List<Continent> get continents => _continents;

  /// Selected continent.
  /// Null means no continent is selected.
  String? get selectedContinent => _selectedContinent;

  /// Set selected continent.
  /// Set to null to clear the selection.
  set selectedContinent(String? continent) {
    _selectedContinent = continent;
    _log.finest('Selected continent: $continent');
    notifyListeners();
  }

  /// Date range.
  /// Null means no range is selected.
  DateTimeRange? get dateRange => _dateRange;

  /// Set date range.
  /// Can be set to null to clear selection.
  set dateRange(DateTimeRange? dateRange) {
    _dateRange = dateRange;
    _log.finest('Selected date range: $dateRange');
    notifyListeners();
  }

  /// Number of guests
  int get guests => _guests;

  /// Set number of guests
  /// If the quantity is negative, it will be set to 0
  set guests(int quantity) {
    if (quantity < 0) {
      _guests = 0;
    } else {
      _guests = quantity;
    }
    _log.finest('Set guests number: $_guests');
    notifyListeners();
  }

  void reset() {
    _selectedContinent = null;
    _dateRange = null;
    _guests = 0;
    notifyListeners();
  }

  late final loadDataCommand = Command.createAsyncNoParamNoResult(
    () async {
      _continents = await getContinents();
      final itineraryConfig =
          await di<ItineraryConfigManager>().getItineraryConfig();
      _selectedContinent = itineraryConfig.continent;
      if (itineraryConfig.startDate != null &&
          itineraryConfig.endDate != null) {
        _dateRange = DateTimeRange(
          start: itineraryConfig.startDate!,
          end: itineraryConfig.endDate!,
        );
      }
      _guests = itineraryConfig.guests ?? 0;
      _log.fine('ItineraryConfig loaded');
    },
  );

  late final updateItineraryConfigCommand = Command.createAsyncNoParamNoResult(
    () async {
      final resultConfig =
          await di<ItineraryConfigManager>().getItineraryConfig();

      await di<ItineraryConfigManager>().setItineraryConfig(
        resultConfig.copyWith(
          continent: _selectedContinent,
          startDate: _dateRange!.start,
          endDate: _dateRange!.end,
          guests: _guests,
        ),
      );
    },
  );
}
