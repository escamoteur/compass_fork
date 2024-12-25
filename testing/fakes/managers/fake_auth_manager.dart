// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/auth/_managers/auth_manager_.dart';
import 'package:compass_app/_features/auth/_model/user.dart';
import 'package:flutter_command/flutter_command.dart';

import '../../models/user.dart';

class FakeAuthManager extends AuthManager {
  String? token;

  @override
  bool get isAuthenticated => token != null;

  @override
  Future<void> logout() async {
    token = null;
    await super.logout();
  }

  @override
  Command<void, UserProxy?> getCurrentUserCommand =
      Command.createAsyncNoParam<UserProxy?>(() async {
    return user;
  }, initialValue: null);

  @override
  Future<AuthManager> init() {
    return Future.value(this);
  }

  @override
  late final Command<({String email, String password}), void> loginCommand =
      Command.createAsyncNoResult<({String email, String password})>(
          (params) async {
    token = 'TOKEN';
  });
}
