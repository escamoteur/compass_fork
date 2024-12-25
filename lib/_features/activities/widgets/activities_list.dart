// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/ui/themes/dimens.dart';
import '../_managers/activity_manager_.dart';
import '../_model/activity.dart';
import 'activity_entry.dart';

class ActivitiesList extends WatchingWidget {
  const ActivitiesList({
    super.key,
    required this.activities,
  });

  final List<Activity> activities;

  @override
  Widget build(BuildContext context) {
    final selectedActivities = watchIt<ActivityManager>().selectedActivities;
    return SliverPadding(
      padding: EdgeInsets.only(
        top: Dimens.paddingVertical,
        left: Dimens.of(context).paddingScreenHorizontal,
        right: Dimens.of(context).paddingScreenHorizontal,
        bottom: Dimens.paddingVertical,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final activity = activities[index];
            return Padding(
              padding: EdgeInsets.only(
                  bottom: index < activities.length - 1 ? 20 : 0),
              child: ActivityEntry(
                key: ValueKey(activity.ref),
                activity: activity,
                selected: selectedActivities.contains(activity.ref),
                onChanged: (value) {
                  if (value!) {
                    di<ActivityManager>().addActivity(activity.ref);
                  } else {
                    di<ActivityManager>().removeActivity(activity.ref);
                  }
                },
              ),
            );
          },
          childCount: activities.length,
        ),
      ),
    );
  }
}
