// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/itinerary_config/__manager/itinerary_config_manager_.dart';
import '../../../_shared/itinerary_config/itinerary_config.dart';
import '../_model/user.dart';

abstract class AuthManager extends ChangeNotifier {
  /// Returns true when the user is logged in
  bool get isAuthenticated;

  Future<AuthManager> init();

  Command<({String email, String password}), void> get loginCommand;

  late final Command<void, void> logoutCommand =
      Command.createAsyncNoParamNoResult(() => logout(),
          errorFilter: ErrorHandlerLocalAndGlobal());

  @mustCallSuper
  Future<void> logout() async {
    await di<ItineraryConfigManager>()
        .setItineraryConfig(const ItineraryConfig());
  }

  /// Get current user
  Command<void, UserProxy?> get getCurrentUserCommand;
}
