// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_shared/itinerary_config/__manager/itinerary_config_manager_.dart';
import 'package:compass_app/_shared/itinerary_config/itinerary_config.dart';
import 'package:flutter/foundation.dart';

class FakeItineraryConfigManager implements ItineraryConfigManager {
  FakeItineraryConfigManager({this.itineraryConfig});

  ItineraryConfig? itineraryConfig;

  @override
  Future<ItineraryConfig> getItineraryConfig() {
    return SynchronousFuture(itineraryConfig ?? const ItineraryConfig());
  }

  @override
  Future<void> setItineraryConfig(ItineraryConfig itineraryConfig) {
    this.itineraryConfig = itineraryConfig;
    return SynchronousFuture(null);
  }
}
