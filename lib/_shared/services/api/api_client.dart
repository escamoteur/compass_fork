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
import 'model/booking/booking_api_model.dart';
import 'model/login_request/login_request.dart';
import 'model/login_response/login_response.dart';
import 'model/user/user_api_model.dart';

/// Adds the `Authentication` header to a header configuration.
typedef AuthHeaderProvider = String? Function();

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.innerException});

  final String message;
  final int? statusCode;
  final Object? innerException;

  @override
  String toString() => 'ApiException: $message, statusCode: $statusCode';
}

class ApiClient {
  ApiClient({
    String? host,
    int? port,
    Map<String, String>? headerParams,
    Client Function()? clientFactory,
    this.authToken,
  })  : _host = host ?? 'localhost',
        _port = port ?? 8080,
        _headerParams = headerParams ?? {} {
    _client ??= clientFactory?.call() ?? IOClient(HttpClient());
  }

  final String _host;
  final int _port;
  final Map<String, String> _headerParams;
  final String? authToken;

  /// An app should use a single client for all requests.
  static Client? _client;

  Future<void> _applyAuth() async {
    if (authToken != null) {
      _headerParams
          .addAll({HttpHeaders.authorizationHeader: 'Bearer $authToken'});
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

  Future<List<Continent>> getContinents() async {
    try {
      final response = await get('/continent');
      if (response.statusCode == 200) {
        final stringData = utf8.decode(response.bodyBytes);
        final json = jsonDecode(stringData) as List<dynamic>;
        return json.map((element) => Continent.fromJson(element)).toList();
      } else {
        throw ApiException("Error fetching continents",
            statusCode: response.statusCode);
      }
    } catch (error) {
      throw ApiException("Error fetching continents", innerException: error);
    }
  }

  Future<List<Destination>> getDestinations() async {
    try {
      final response = await get('/destination');
      if (response.statusCode == 200) {
        final stringData = utf8.decode(response.bodyBytes);
        final json = jsonDecode(stringData) as List<dynamic>;
        return json.map((element) => Destination.fromJson(element)).toList();
      } else {
        throw ApiException("Error fetching destinations",
            statusCode: response.statusCode);
      }
    } catch (error) {
      throw ApiException("Error fetching destinations", innerException: error);
    }
  }

  Future<List<Activity>> getActivityByDestination(String ref) async {
    try {
      final response = await get('/destination/$ref/activity');
      if (response.statusCode == 200) {
        final stringData = utf8.decode(response.bodyBytes);
        final json = jsonDecode(stringData) as List<dynamic>;
        return json.map((element) => Activity.fromJson(element)).toList();
      } else {
        throw ApiException("Error fetching activities",
            statusCode: response.statusCode);
      }
    } catch (error) {
      throw ApiException("Error fetching activities", innerException: error);
    }
  }

  Future<List<BookingApiModel>> getBookings() async {
    try {
      final response = await get('/booking');
      if (response.statusCode == 200) {
        final stringData = utf8.decode(response.bodyBytes);
        final json = jsonDecode(stringData) as List<dynamic>;
        return json
            .map((element) => BookingApiModel.fromJson(element))
            .toList();
      } else {
        throw ApiException("Error fetching bookings",
            statusCode: response.statusCode);
      }
    } catch (error) {
      throw ApiException("Error fetching bookings", innerException: error);
    }
  }

  Future<BookingApiModel> getBooking(int id) async {
    try {
      final response = await get('/booking/$id');
      if (response.statusCode == 200) {
        final stringData = utf8.decode(response.bodyBytes);
        return BookingApiModel.fromJson(jsonDecode(stringData));
      } else {
        throw ApiException("Error fetching bookings",
            statusCode: response.statusCode);
      }
    } catch (error) {
      throw ApiException("Error fetching bookings", innerException: error);
    }
  }

  Future<BookingApiModel> postBooking(BookingApiModel booking) async {
    try {
      final response = await post('/booking', jsonEncode(booking));
      if (response.statusCode == 201) {
        final stringData = utf8.decode(response.bodyBytes);
        return BookingApiModel.fromJson(jsonDecode(stringData));
      } else {
        throw ApiException("Error creating booking",
            statusCode: response.statusCode);
      }
    } catch (error) {
      throw ApiException("Error creating booking", innerException: error);
    }
  }

  Future<UserApiModel> getUser() async {
    try {
      final response = await get('/user');
      if (response.statusCode == 200) {
        final stringData = utf8.decode(response.bodyBytes);
        final user = UserApiModel.fromJson(jsonDecode(stringData));
        return user;
      } else {
        throw ApiException("Failed to load User",
            statusCode: response.statusCode);
      }
    } catch (error) {
      throw ApiException("Failed to load User", innerException: error);
    }
  }

  Future<void> deleteBooking(int id) async {
    try {
      final response = await delete('/booking/$id');
      // Response 204 "No Content", delete was successful
      if (response.statusCode == 204) {
        return;
      } else {
        throw ApiException("Error deleting booking",
            statusCode: response.statusCode);
      }
    } catch (error) {
      throw ApiException("Error deleting booking", innerException: error);
    }
  }

  Future<LoginResponse> login(LoginRequest loginRequest) async {
    assert(authToken == null, 'Already logged in');
    try {
      final response = await post('/login', jsonEncode(loginRequest));
      if (response.statusCode == 200) {
        final stringData = utf8.decode(response.bodyBytes);
        return LoginResponse.fromJson(jsonDecode(stringData));
      } else {
        throw ApiException('Failed to login', statusCode: response.statusCode);
      }
    } catch (error) {
      throw ApiException('Failed to login', innerException: error);
    }
  }
}
