// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../../_repo/auth_repository.dart';
import '../../../../_shared/itinerary_config/_repo/itinerary_config_repository.dart';
import '../../../../_shared/itinerary_config/itinerary_config.dart';
import '../../../../_shared/utils/command.dart';
import '../../../../_shared/utils/result.dart';

class LogoutViewModel {
  LogoutViewModel({
    required AuthRepository authRepository,
    required ItineraryConfigRepository itineraryConfigRepository,
  })  : _authLogoutRepository = authRepository,
        _itineraryConfigRepository = itineraryConfigRepository {
    logout = Command0(_logout);
  }
  final AuthRepository _authLogoutRepository;
  final ItineraryConfigRepository _itineraryConfigRepository;
  late Command0 logout;

  Future<Result> _logout() async {
    var result = await _authLogoutRepository.logout();
    switch (result) {
      case Ok<void>():
        // clear stored itinerary config
        return _itineraryConfigRepository
            .setItineraryConfig(const ItineraryConfig());
      case Error<void>():
        return result;
    }
  }
}
