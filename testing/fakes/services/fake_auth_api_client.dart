// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_shared/services/api/auth_api_client.dart';
import 'package:compass_app/_shared/services/api/model/login_request/login_request.dart';
import 'package:compass_app/_shared/services/api/model/login_response/login_response.dart';
import 'package:compass_app/_shared/utils/result.dart';

class FakeAuthApiClient implements AuthApiClient {
  @override
  Future<Result<LoginResponse>> login(LoginRequest loginRequest) async {
    if (loginRequest.email == 'EMAIL' && loginRequest.password == 'PASSWORD') {
      return Result.ok(const LoginResponse(token: 'TOKEN', userId: '123'));
    }
    return Result.error(Exception('ERROR!'));
  }
}