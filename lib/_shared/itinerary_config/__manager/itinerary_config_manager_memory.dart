// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import '../itinerary_config.dart';
import 'itinerary_config_manager_.dart';

/// In-memory implementation of [ItineraryConfigManager].
class ItineraryConfigManagerMemory extends ItineraryConfigManager {
  ItineraryConfig? _itineraryConfig;

  @override
  Future<ItineraryConfig> getItineraryConfig() async {
    return _itineraryConfig ?? const ItineraryConfig();
  }

  @override
  Future<bool> setItineraryConfig(
    ItineraryConfig itineraryConfig,
  ) async {
    _itineraryConfig = itineraryConfig;
    return true;
  }
}
