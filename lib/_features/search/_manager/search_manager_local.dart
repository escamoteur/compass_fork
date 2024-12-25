// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../../../_shared/services/local/local_data_service.dart';
import '../_model/continent.dart';
import 'search_manager_.dart';

/// Local data source with all possible continents.
class SearchManagerLocal extends SearchManager {
  SearchManagerLocal({
    required LocalDataService localDataService,
  }) : _localDataService = localDataService;

  final LocalDataService _localDataService;

  @override
  Future<List<Continent>> getContinents() async {
    return _localDataService.getContinents();
  }
}
