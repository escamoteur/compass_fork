// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/auth/_managers/user_repository.dart';
import 'package:compass_app/_features/auth/_model/user.dart';
import 'package:compass_app/_shared/utils/result.dart';

import '../../models/user.dart';

class FakeUserRepository implements UserRepository {
  @override
  Future<UserProxy> getUser() async {
    return Result.ok(user);
  }
}
