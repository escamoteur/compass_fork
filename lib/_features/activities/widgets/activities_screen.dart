// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watch_it/watch_it.dart';

import '../../../routing/routes.dart';
import '../_managers/activity_manager_.dart';
import 'activities_body.dart';

class ActivitiesScreen extends WatchingWidget {
  const ActivitiesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    registerHandler(
        select: (ActivityManager m) => m.loadActivitiesCommand,
        handler: (context, _, __) {
          context.go(Routes.booking);
        });
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, r) {
        if (!didPop) context.go(Routes.results);
      },
      child: Scaffold(
        body: const ActivitiesBody(),
      ),
    );
  }
}
