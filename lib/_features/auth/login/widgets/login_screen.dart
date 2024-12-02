// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watch_it/watch_it.dart';

import '../../../../_shared/ui/localization/applocalization.dart';
import '../../../../_shared/ui/themes/dimens.dart';
import '../../../../routing/routes.dart';
import '../../_managers/auth_manager_.dart';
import 'tilted_cards.dart';

class LoginScreen extends WatchingStatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email =
      TextEditingController(text: 'email@example.com');
  final TextEditingController _password =
      TextEditingController(text: 'password');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    registerHandler(
        select: (AuthManager authManager) => authManager.loginCommand.results,
        handler: (context, result, _) {
          if (result.hasData) _onResult(true);
          if (result.hasError) _onResult(false);
        });
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const TiltedCards(),
          Padding(
            padding: Dimens.of(context).edgeInsetsScreenSymmetric,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _email,
                ),
                const SizedBox(height: Dimens.paddingVertical),
                TextField(
                  controller: _password,
                  obscureText: true,
                ),
                const SizedBox(height: Dimens.paddingVertical),
                FilledButton(
                  onPressed: () => di<AuthManager>().loginCommand((
                    email: _email.value.text,
                    password: _password.value.text
                  )),
                  child: Text(AppLocalization.of(context).login),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onResult(bool success) {
    if (success) {
      context.go(Routes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalization.of(context).errorWhileLogin),
          action: SnackBarAction(
            label: AppLocalization.of(context).tryAgain,
            onPressed: () => di<AuthManager>().loginCommand(
                (email: _email.value.text, password: _password.value.text)),
          ),
        ),
      );
    }
  }
}
