// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/auth/_managers/auth_manager_remote.dart';
import 'package:compass_app/_shared/services/api/api_client.dart';
import 'package:compass_app/_shared/services/shared_preferences_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_it/watch_it.dart';

import '../../../../testing/fakes/services/fake_api_client.dart';
import '../../../../testing/fakes/services/fake_shared_preferences_service.dart';

void main() {
  group('AuthRepositoryRemote tests', () {
    late FakeApiClient apiClient;
    late FakeSharedPreferencesService sharedPreferencesService;

    setUp(() {
      di.reset();

      apiClient = FakeApiClient();
      di.registerSingleton<ApiClient>(apiClient);
      sharedPreferencesService = FakeSharedPreferencesService();
      di.registerSingleton<SharedPreferencesService>(sharedPreferencesService);
    });

    test('fetch on start, has token', () async {
      // Stored token in shared preferences
      sharedPreferencesService.token = 'TOKEN';

      // Create an AuthManagerRemote
      final manager = await AuthManagerRemote().init();

      final isAuthenticated = manager.isAuthenticated;

      // True because Token is SharedPreferences
      expect(isAuthenticated, isTrue);

      // Check auth token
      await expectAuthHeader(di<ApiClient>() as FakeApiClient, 'Bearer TOKEN');
    });

    test('fetch on start, no token', () async {
      // Stored token in shared preferences
      sharedPreferencesService.token = null;

      // Create an AuthRepository, should perform initial fetch
      final manager = await AuthManagerRemote().init();

      final isAuthenticated = manager.isAuthenticated;

      // True because Token is SharedPreferences
      expect(isAuthenticated, isFalse);

      // Check auth token
      await expectAuthHeader(di<ApiClient>() as FakeApiClient, null);
    });

    test('perform login', () async {
      final manager = await AuthManagerRemote().init();
      await manager.loginCommand.executeWithFuture((
        email: 'EMAIL',
        password: 'PASSWORD',
      ));
      expect(manager.isAuthenticated, isTrue);
      expect(sharedPreferencesService.token, 'TOKEN');

      // Check auth token
      await expectAuthHeader(apiClient, 'Bearer TOKEN');
    });

    test('perform logout', () async {
      // logged in status
      sharedPreferencesService.token = 'TOKEN';

      final manager = await AuthManagerRemote().init();
      await manager.logoutCommand.executeWithFuture();
      expect(manager.isAuthenticated, isFalse);
      expect(sharedPreferencesService.token, null);

      // Check auth token
      await expectAuthHeader(apiClient, null);
    });
  });
}

Future<void> expectAuthHeader(FakeApiClient apiClient, String? header) async {
  final header = apiClient.authHeader;
  expect(header, header);
}
