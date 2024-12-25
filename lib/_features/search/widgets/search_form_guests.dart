// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/ui/themes/colors.dart';
import '../../../_shared/ui/themes/dimens.dart';
import '../_manager/search_manager_.dart';

const String removeGuestsKey = 'remove-guests';
const String addGuestsKey = 'add-guests';

/// Number of guests selection form
///
/// Users can tap the Plus and Minus icons to increase or decrease
/// the number of guests.
class SearchFormGuests extends StatelessWidget {
  const SearchFormGuests({
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
                'Who',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              _QuantitySelector(),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            key: const ValueKey(removeGuestsKey),
            onTap: () {
              di<SearchManager>().guests--;
            },
            child: const Icon(
              Icons.remove_circle_outline,
              color: AppColors.grey3,
            ),
          ),
          ListenableBuilder(
            listenable: di<SearchManager>(),
            builder: (context, _) => Text(
              di<SearchManager>().guests.toString(),
              style: di<SearchManager>().guests == 0
                  ? Theme.of(context).inputDecorationTheme.hintStyle
                  : Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          InkWell(
            key: const ValueKey(addGuestsKey),
            onTap: () {
              di<SearchManager>().guests++;
            },
            child: const Icon(
              Icons.add_circle_outline,
              color: AppColors.grey3,
            ),
          ),
        ],
      ),
    );
  }
}
