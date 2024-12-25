// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/search/_manager/search_manager_.dart';
import 'package:compass_app/_features/search/_model/continent.dart';
import 'package:flutter/foundation.dart';

class FakeSearchManager extends SearchManager {
  @override
  Future<List<Continent>> getContinents() {
    return SynchronousFuture([
      const Continent(name: 'CONTINENT', imageUrl: 'URL'),
      const Continent(name: 'CONTINENT2', imageUrl: 'URL'),
      const Continent(name: 'CONTINENT3', imageUrl: 'URL'),
    ]);
  }
}
