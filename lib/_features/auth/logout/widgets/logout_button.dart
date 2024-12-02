// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../../_shared/ui/localization/applocalization.dart';
import '../../../../_shared/ui/themes/colors.dart';
import '../../_managers/auth_manager_.dart';

class LogoutButton extends WatchingWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    registerHandler(
      select: (AuthManager authManager) => authManager.logoutCommand.errors,
      handler: (context, result, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalization.of(context).errorWhileLogout),
            action: SnackBarAction(
              label: AppLocalization.of(context).tryAgain,
              onPressed: di<AuthManager>().logoutCommand.execute,
            ),
          ),
        );
      },
    );
    return SizedBox(
      height: 40.0,
      width: 40.0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey1),
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.transparent,
        ),
        child: InkResponse(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            di<AuthManager>().logoutCommand();
          },
          child: Center(
            child: Icon(
              size: 24.0,
              Icons.logout,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
