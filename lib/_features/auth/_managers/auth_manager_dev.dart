// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_command/flutter_command.dart';

import '../../../_shared/services/local/local_data_service.dart';
import '../_model/user.dart';
import 'auth_manager_.dart';

class AuthManagerDev extends AuthManager {
  AuthManagerDev({
    required LocalDataService localDataService,
  }) : _localDataService = localDataService;

  final LocalDataService _localDataService;

  @override
  Future<AuthManagerDev> init() async {
    return this;
  }

  /// User is always authenticated in dev scenarios
  @override
  bool get isAuthenticated => true;

  /// Login is always successful in dev scenarios
  @override
  late final Command<({String email, String password}), void> loginCommand =
      Command.createAsyncNoResult((credentials) async {});

  @override
  late final Command<void, UserProxy?> getCurrentUserCommand =
      Command.createAsyncNoParam<UserProxy?>(() async {
    return _localDataService.getUser();
  }, initialValue: null);
}
