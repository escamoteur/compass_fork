// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'api_client.dart';

import '../../utils/result.dart';
import 'model/login_request/login_request.dart';
import 'model/login_response/login_response.dart';

class AuthApiClient extends ApiClient {
  AuthApiClient({
    super.host,
    super.port,
    super.headerParams,
    super.clientFactory,
  });

  Future<Result<LoginResponse>> login(LoginRequest loginRequest) async {
    try {
      final response = await post('/login', jsonEncode(loginRequest));
      if (response.statusCode == 200) {
        final stringData = utf8.decode(response.bodyBytes);
        return Result.ok(LoginResponse.fromJson(jsonDecode(stringData)));
      } else {
        return Result.error(const HttpException("Login error"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
