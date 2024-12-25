// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:go_router/go_router.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/ui/localization/applocalization.dart';
import '../../../_shared/ui/themes/dimens.dart';
import '../../../_shared/ui/ui/error_indicator.dart';
import '../../../routing/routes.dart';
import '../_managers/activity_manager_.dart';
import 'activities_header.dart';
import 'activities_list.dart';
import 'activities_title.dart';

const String confirmButtonKey = 'confirm-button';

class ActivitiesScreen extends WatchingWidget {
  const ActivitiesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    registerHandler(
        select: (ActivityManager m) => m.saveActivitiesCommand,
        handler: (context, _, __) {
          context.go(Routes.booking);
        });
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, r) {
        if (!didPop) context.go(Routes.results);
      },
      child: Scaffold(
        body: Column(
          children: [
            const ActivitiesHeader(),
            CommandBuilder(
              command: di<ActivityManager>().loadActivitiesCommand,
              whileExecuting: (context, lastValue, param) => const Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
              onError: (context, error, _, __) => Expanded(
                child: Center(
                  child: ErrorIndicator(
                    title:
                        AppLocalization.of(context).errorWhileLoadingActivities,
                    label: AppLocalization.of(context).tryAgain,
                    onPressed:
                        di<ActivityManager>().loadActivitiesCommand.execute,
                  ),
                ),
              ),
              onSuccess: (context, param) => Expanded(
                child: CustomScrollView(
                  slivers: [
                    if (di<ActivityManager>().daytimeActivities.isNotEmpty) ...[
                      ActivitiesTitle(
                        title: AppLocalization.of(context).daytime,
                      ),
                      ActivitiesList(
                        activities: di<ActivityManager>().daytimeActivities,
                      ),
                    ],
                    if (di<ActivityManager>().eveningActivities.isNotEmpty) ...[
                      ActivitiesTitle(
                        title: AppLocalization.of(context).evening,
                      ),
                      ActivitiesList(
                        activities: di<ActivityManager>().eveningActivities,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            _BottomArea(),
          ],
        ),
      ),
    );
  }
}

class _BottomArea extends WatchingWidget {
  const _BottomArea();

  @override
  Widget build(BuildContext context) {
    registerHandler(
        select: (ActivityManager m) => m.saveActivitiesCommand.errors,
        handler: (context, error, __) {
          if (error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    AppLocalization.of(context).errorWhileSavingActivities),
                action: SnackBarAction(
                  label: AppLocalization.of(context).tryAgain,
                  onPressed:
                      di<ActivityManager>().saveActivitiesCommand.execute,
                ),
              ),
            );
          }
        });

    final selectedActivities = watchIt<ActivityManager>().selectedActivities;

    return SafeArea(
      bottom: true,
      child: Material(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.only(
            left: Dimens.of(context).paddingScreenHorizontal,
            right: Dimens.of(context).paddingScreenVertical,
            top: Dimens.paddingVertical,
            bottom: Dimens.of(context).paddingScreenVertical,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalization.of(context).selected(selectedActivities.length),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              FilledButton(
                key: const Key(confirmButtonKey),
                onPressed: selectedActivities.isNotEmpty
                    ? di<ActivityManager>().saveActivitiesCommand.execute
                    : null,
                child: Text(AppLocalization.of(context).confirm),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
