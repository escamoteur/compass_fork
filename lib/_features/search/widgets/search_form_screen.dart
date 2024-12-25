// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/ui/themes/dimens.dart';
import '../../../_shared/ui/ui/search_bar.dart';
import '../../../routing/routes.dart';
import '../../results/results_screen.dart';
import '../_manager/search_manager_.dart';
import 'search_form_continent.dart';
import 'search_form_date.dart';
import 'search_form_guests.dart';
import 'search_form_submit.dart';

/// Search form screen
///
/// Displays a search form with continent, date and guests selection.
/// Tapping on the submit button opens the [ResultsScreen] screen
/// passing the search options as query parameters.
class SearchFormScreen extends WatchingWidget {
  const SearchFormScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    callOnce((_) {
      di<SearchManager>().loadDataCommand.execute();
    });
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, r) {
        if (!didPop) context.go(Routes.home);
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SafeArea(
              top: true,
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(
                  top: Dimens.of(context).paddingScreenVertical,
                  left: Dimens.of(context).paddingScreenHorizontal,
                  right: Dimens.of(context).paddingScreenHorizontal,
                  bottom: Dimens.paddingVertical,
                ),
                child: const AppSearchBar(),
              ),
            ),
            const SearchFormContinent(),
            const SearchFormDate(),
            const SearchFormGuests(),
            const Spacer(),
            const SearchFormSubmit(),
          ],
        ),
      ),
    );
  }
}
