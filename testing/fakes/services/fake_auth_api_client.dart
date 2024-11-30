// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/activities/_model/activity.dart';
import 'package:compass_app/_features/search/_model/continent.dart';
import 'package:compass_app/_features/search/_model/destination.dart';
import 'package:compass_app/_shared/services/api/api_client.dart';
import 'package:compass_app/_shared/services/api/auth_api_client.dart';
import 'package:compass_app/_shared/services/api/model/booking/booking_api_model.dart';
import 'package:compass_app/_shared/services/api/model/login_request/login_request.dart';
import 'package:compass_app/_shared/services/api/model/login_response/login_response.dart';
import 'package:compass_app/_shared/services/api/model/user/user_api_model.dart';
import 'package:compass_app/_shared/utils/result.dart';
import 'package:http/src/response.dart';

class FakeAuthApiClient implements AuthApiClient {
  @override
  Future<Result<LoginResponse>> login(LoginRequest loginRequest) async {
    if (loginRequest.email == 'EMAIL' && loginRequest.password == 'PASSWORD') {
      return Result.ok(const LoginResponse(token: 'TOKEN', userId: '123'));
    }
    return Result.error(Exception('ERROR!'));
  }

  @override
  set authHeaderProvider(AuthHeaderProvider authHeaderProvider) {
    // TODO: implement authHeaderProvider
  }

  @override
  Future<Response> delete(String path) {
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> deleteBooking(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Response> get(String path) {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Activity>>> getActivityByDestination(String ref) {
    throw UnimplementedError();
  }

  @override
  Future<Result<BookingApiModel>> getBooking(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<BookingApiModel>>> getBookings() {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Continent>>> getContinents() {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Destination>>> getDestinations() {
    throw UnimplementedError();
  }

  @override
  Future<Result<UserApiModel>> getUser() {
    throw UnimplementedError();
  }

  @override
  Future<Response> post(String path, body) {
    throw UnimplementedError();
  }

  @override
  Future<Result<BookingApiModel>> postBooking(BookingApiModel booking) {
    throw UnimplementedError();
  }
}
