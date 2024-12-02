// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const _tokenKey = 'TOKEN';
  final _log = Logger('SharedPreferencesService');

  Future<String?> fetchToken() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      _log.finer('Got token from SharedPreferences');
      return sharedPreferences.getString(_tokenKey);
    } on Exception {
      throw Exception('Failed to get auth token');
    }
  }

  Future<void> saveToken(String? token) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      if (token == null) {
        _log.finer('Removed token');
        await sharedPreferences.remove(_tokenKey);
      } else {
        _log.finer('Replaced token');
        await sharedPreferences.setString(_tokenKey, token);
      }
    } on Exception {
      throw Exception('Failed to set auth token');
    }
  }
}
