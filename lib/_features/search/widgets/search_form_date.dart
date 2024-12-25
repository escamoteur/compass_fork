// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/ui/localization/applocalization.dart';
import '../../../_shared/ui/themes/dimens.dart';
import '../../../_shared/ui/ui/date_format_start_end.dart';
import '../../../_shared/ui/themes/colors.dart';
import '../_manager/search_manager_.dart';

/// Date selection form field.
///
/// Opens a date range picker dialog when tapped.
class SearchFormDate extends StatelessWidget {
  const SearchFormDate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimens.paddingVertical,
        left: Dimens.of(context).paddingScreenHorizontal,
        right: Dimens.of(context).paddingScreenHorizontal,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          showDateRangePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          ).then((dateRange) => di<SearchManager>().dateRange = dateRange);
        },
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey1),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.paddingHorizontal,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalization.of(context).when,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ListenableBuilder(
                  listenable: di<SearchManager>(),
                  builder: (context, _) {
                    final dateRange = di<SearchManager>().dateRange;
                    if (dateRange != null) {
                      return Text(
                        dateFormatStartEnd(dateRange),
                        style: Theme.of(context).textTheme.bodyLarge,
                      );
                    } else {
                      return Text(
                        AppLocalization.of(context).addDates,
                        style: Theme.of(context).inputDecorationTheme.hintStyle,
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
