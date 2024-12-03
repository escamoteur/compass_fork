// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/booking/_repo/destination_repository.dart';
import 'package:compass_app/_features/search/_model/destination.dart';
import 'package:flutter/foundation.dart';

import '../../models/destination.dart';

class FakeDestinationRepository implements DestinationRepository {
  @override
  Future<List<Destination>> getDestinations() {
    return SynchronousFuture([kDestination1, kDestination2]);
  }
}
