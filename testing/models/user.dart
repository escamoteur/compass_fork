// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/auth/_model/user.dart';
import 'package:compass_app/_shared/services/api/model/user/user_api_model.dart';

const userApiModel = UserApiModel(
  id: 'ID',
  name: 'NAME',
  email: 'EMAIL',
  picture: 'assets/user.jpg',
);

const user = UserProxy(
  name: 'NAME',
  picture: 'assets/user.jpg',
);
