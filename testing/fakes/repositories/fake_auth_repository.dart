// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/auth/_managers/auth_manager_.dart';
import 'package:compass_app/_shared/utils/result.dart';

class FakeAuthRepository extends AuthManager {
  String? token;

  @override
  Future<bool> get isAuthenticated async => token != null;

  @override
  Future<void>> login({
    required String email,
    required String password,
  }) async {
    token = 'TOKEN';
    notifyListeners();
    return Result.ok(null);
  }

  @override
  Future<void>> logout() async {
    token = null;
    notifyListeners();
    return Result.ok(null);
  }
}
