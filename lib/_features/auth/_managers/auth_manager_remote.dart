// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_command/flutter_command.dart';
import 'package:logging/logging.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/services/api/api_client.dart';
import '../../../_shared/services/api/model/login_request/login_request.dart';
import '../../../_shared/services/shared_preferences_service.dart';
import '../_model/user.dart';
import 'auth_manager_.dart';

class AuthManagerRemote extends AuthManager {
  String? _authToken;
  final _log = Logger('AuthRepositoryRemote');

  /// Fetch token from shared preferences
  @override
  Future<AuthManagerRemote> init() async {
    final result = await di<SharedPreferencesService>().fetchToken();
    _authToken = result;
    return this;
  }

  @override
  bool get isAuthenticated => _authToken != null;

  @override
  late Command<({String email, String password}), void> loginCommand =
      Command.createAsyncNoResult(
    (credentials) async {
      try {
        final result = await di<ApiClient>().login(
          LoginRequest(
            email: credentials.email,
            password: credentials.password,
          ),
        );
        _log.info('User logged int');
        // Set auth status
        _authToken = result.token;
        // Store in Shared preferences
        await di<SharedPreferencesService>().saveToken(result.token);

        /// Push new scope for logged in user
        di.pushNewScope(
          init: (getIt) => getIt
              .registerSingleton<ApiClient>(ApiClient(authToken: _authToken!)),
          scopeName: 'logged_in',
        );
      } finally {
        /// TODO Not sure yet if we will keet this here because the commands can directly be observed
        notifyListeners();
      }
    },
  );

  @override
  late Command<void, void> logoutCommand = Command.createAsyncNoParamNoResult(
    () async {
      try {
        assert(_authToken != null, 'User is not logged in');
        // Clear stored auth token
        await di<SharedPreferencesService>().saveToken(null);

        // Clear token in ApiClient
        _authToken = null;
        di.popScope();
        _log.info('User logged out');
      } finally {
        notifyListeners();
      }
    },
  );

  User? _cachedData;

  @override
  late Command<void, User?> getCurrentUserCommand =
      Command.createAsyncNoParam(() async {
    if (_cachedData != null) {
      return _cachedData;
    }

    final result = await di<ApiClient>().getUser();
    final user = User(
      name: result.name,
      picture: result.picture,
    );
    _cachedData = user;
    return user;
  }, initialValue: null);
}
