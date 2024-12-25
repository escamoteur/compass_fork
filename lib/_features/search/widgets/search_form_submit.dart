// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:go_router/go_router.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/ui/localization/applocalization.dart';
import '../../../_shared/ui/themes/dimens.dart';
import '../../../routing/routes.dart';
import '../../results/results_screen.dart';
import '../_manager/search_manager_.dart';

const String searchFormSubmitButtonKey = 'submit-button';

/// Search form submit button
///
/// The button is disabled when the form is data is incomplete.
/// When tapped, it navigates to the [ResultsScreen]
/// passing the search options as query parameters.
class SearchFormSubmit extends WatchingWidget {
  const SearchFormSubmit({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    registerHandler(
      select: (SearchManager manager) =>
          manager.updateItineraryConfigCommand.results,
      handler: _onResult,
    );
    final isValid =
        watchPropertyValue((SearchManager manager) => manager.valid);
    return Padding(
      padding: EdgeInsets.only(
        top: Dimens.paddingVertical,
        left: Dimens.of(context).paddingScreenHorizontal,
        right: Dimens.of(context).paddingScreenHorizontal,
        bottom: Dimens.of(context).paddingScreenVertical,
      ),
      child: FilledButton(
        key: const ValueKey(searchFormSubmitButtonKey),
        onPressed: isValid
            ? di<SearchManager>().updateItineraryConfigCommand.execute
            : null,
        child: SizedBox(
          height: 52,
          child: Center(
            child: Text(AppLocalization.of(context).search),
          ),
        ),
      ),
    );
  }

  void _onResult(BuildContext context, CommandResult result, cancel) {
    if (!result.isExecuting && !result.hasError) {
      context.go(Routes.results);
    }
    if (result.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalization.of(context).errorWhileSavingItinerary),
        action: SnackBarAction(
          label: AppLocalization.of(context).tryAgain,
          onPressed: di<SearchManager>().updateItineraryConfigCommand.execute,
        ),
      ));
    }
  }
}
