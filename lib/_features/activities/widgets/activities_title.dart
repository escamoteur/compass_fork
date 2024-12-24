// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../../_shared/ui/localization/applocalization.dart';
import '../../../_shared/ui/themes/dimens.dart';
import 'activity_time_of_day.dart';

class ActivitiesTitle extends StatelessWidget {
  const ActivitiesTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: Dimens.of(context).edgeInsetsScreenHorizontal,
        child: Text(title),
      ),
    );
  }
}
