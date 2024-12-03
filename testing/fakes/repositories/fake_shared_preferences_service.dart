// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_shared/services/shared_preferences_service.dart';

class FakeSharedPreferencesService implements SharedPreferencesService {
  String? token;

  @override
  Future<String?> fetchToken() async {
    return token;
  }

  @override
  Future<void> saveToken(String? token) async {
    this.token = token;
  }
}
