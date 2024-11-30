// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../../../_features/activities/_model/activity.dart';
import '../../../_features/search/_model/continent.dart';
import '../../../_features/search/_model/destination.dart';
import '../../utils/result.dart';
import 'model/booking/booking_api_model.dart';
import 'model/user/user_api_model.dart';

/// Adds the `Authentication` header to a header configuration.
typedef AuthHeaderProvider = String? Function();

class ApiClient {
  ApiClient({
    String? host,
    int? port,
    Map<String, String>? headerParams,
    Client Function()? clientFactory,
  })  : _host = host ?? 'localhost',
        _port = port ?? 8080,
        _headerParams = headerParams ?? {} {
    _client ??= clientFactory?.call() ?? IOClient(HttpClient());
  }

  final String _host;
  final int _port;
  final Map<String, String> _headerParams;

  /// An app should use a single client for all requests.
  static Client? _client;

  AuthHeaderProvider? _authHeaderProvider;

  set authHeaderProvider(AuthHeaderProvider authHeaderProvider) {
    _authHeaderProvider = authHeaderProvider;
  }

  Future<void> _applyAuth() async {
    final header = _authHeaderProvider?.call();
    if (header != null) {
      _headerParams.addAll({HttpHeaders.authorizationHeader: header});
    }
  }

  Future<Response> post(String path, dynamic body) async {
    final uri = Uri.http('$_host:$_port', path);
    await _applyAuth();
    final request = await _client!.post(uri,
        headers: _headerParams, body: body != null ? jsonEncode(body) : null);
    return request;
  }

  Future<Response> get(String path) async {
    await _applyAuth();
    final uri = Uri.http('$_host:$_port', path);
    final request = await _client!.get(uri, headers: _headerParams);
    return request;
  }

  Future<Response> delete(String path) async {
    await _applyAuth();
    final uri = Uri.http('$_host:$_port', path);
    final request = await _client!.get(uri, headers: _headerParams);
    return request;
  }

  Future<Result<List<Continent>>> getContinents() async {
    try {
      final response = await get('/continent');
      if (response.statusCode == 200) {
        final stringData = utf8.decode(response.bodyBytes);
        final json = jsonDecode(stringData) as List<dynamic>;
        return Result.ok(
            json.map((element) => Continent.fromJson(element)).toList());
      } else {
        return Result.error(const HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<Destination>>> getDestinations() async {
    try {
      final response = await get('/destination');
      if (response.statusCode == 200) {
        final stringData = utf8.decode(response.bodyBytes);
        final json = jsonDecode(stringData) as List<dynamic>;
        return Result.ok(
            json.map((element) => Destination.fromJson(element)).toList());
      } else {
        return Result.error(const HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<Activity>>> getActivityByDestination(String ref) async {
    try {
      final response = await get('/destination/$ref/activity');
      if (response.statusCode == 200) {
        final stringData = utf8.decode(response.bodyBytes);
        final json = jsonDecode(stringData) as List<dynamic>;
        final activities =
            json.map((element) => Activity.fromJson(element)).toList();
        return Result.ok(activities);
      } else {
        return Result.error(const HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<BookingApiModel>>> getBookings() async {
    try {
      final response = await get('/booking');
      if (response.statusCode == 200) {
        final stringData = utf8.decode(response.bodyBytes);
        final json = jsonDecode(stringData) as List<dynamic>;
        final bookings =
            json.map((element) => BookingApiModel.fromJson(element)).toList();
        return Result.ok(bookings);
      } else {
        return Result.error(const HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<BookingApiModel>> getBooking(int id) async {
    try {
      final response = await get('/booking/$id');
      if (response.statusCode == 200) {
        final stringData = utf8.decode(response.bodyBytes);
        final booking = BookingApiModel.fromJson(jsonDecode(stringData));
        return Result.ok(booking);
      } else {
        return Result.error(const HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<BookingApiModel>> postBooking(BookingApiModel booking) async {
    try {
      final response = await post('/booking', jsonEncode(booking));
      if (response.statusCode == 201) {
        final stringData = utf8.decode(response.bodyBytes);
        final booking = BookingApiModel.fromJson(jsonDecode(stringData));
        return Result.ok(booking);
      } else {
        return Result.error(const HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<UserApiModel>> getUser() async {
    try {
      final response = await get('/user');
      if (response.statusCode == 200) {
        final stringData = utf8.decode(response.bodyBytes);
        final user = UserApiModel.fromJson(jsonDecode(stringData));
        return Result.ok(user);
      } else {
        return Result.error(const HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> deleteBooking(int id) async {
    try {
      final response = await delete('/booking/$id');
      // Response 204 "No Content", delete was successful
      if (response.statusCode == 204) {
        return Result.ok(null);
      } else {
        return Result.error(const HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
