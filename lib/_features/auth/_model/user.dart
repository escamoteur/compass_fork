// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

import '../../../_shared/services/api/model/user/user_api_model.dart';

class UserProxy extends ChangeNotifier {
  UserProxy(
    UserApiModel target,
  ) : _target = target;

  UserApiModel _target;

  UserApiModel get target => _target;

  /// if we ever want to update the user from the backend
  set target(UserApiModel target) {
    _target = target;
    notifyListeners();
  }

  /// The user's name.
  String get name => target.name;

  /// The user's picture URL.
  String get picture => target.picture;
}
