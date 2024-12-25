// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/activities/_managers/activity_manager_.dart';
import 'package:compass_app/_features/activities/_model/activity.dart';
import 'package:flutter/foundation.dart';

import '../../models/activity.dart';
import '../../models/destination.dart';

class FakeActivityManager extends ActivityManager {
  Map<String, List<Activity>> activities = {
    "DESTINATION": [kActivity],
    kDestination1.ref: [kActivity],
  };

  @override
  Future<List<Activity>> getByDestination(String ref) {
    return SynchronousFuture(activities[ref]!);
  }
}
