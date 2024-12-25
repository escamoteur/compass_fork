// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/ui/localization/applocalization.dart';
import '../../../_shared/ui/themes/colors.dart';
import '../../../_shared/ui/themes/dimens.dart';
import '../../../_shared/ui/ui/error_indicator.dart';
import '../../../_shared/utils/image_error_listener.dart';
import '../_manager/search_manager_.dart';
import '../_model/continent.dart';

/// Continent selection carousel
///
/// Loads a list of continents in a horizontal carousel.
/// Users can tap one item to select it.
/// Tapping again the same item will deselect it.
class SearchFormContinent extends StatelessWidget {
  const SearchFormContinent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: CommandBuilder(
        command: di<SearchManager>().loadDataCommand,
        whileExecuting: (context, lastValue, param) => const Center(
          child: CircularProgressIndicator(),
        ),
        onError: (context, error, lastValue, param) => Center(
          child: ErrorIndicator(
            title: AppLocalization.of(context).errorWhileLoadingContinents,
            label: AppLocalization.of(context).tryAgain,
            onPressed: di<SearchManager>().loadDataCommand.execute,
          ),
        ),
        onSuccess: (context, param) => ListenableBuilder(
            listenable: di<SearchManager>(),
            builder: (context, snapshot) {
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: di<SearchManager>().continents.length,
                padding: Dimens.of(context).edgeInsetsScreenHorizontal,
                itemBuilder: (BuildContext context, int index) {
                  final Continent(:imageUrl, :name) =
                      di<SearchManager>().continents[index];
                  return _CarouselItem(
                    key: ValueKey(name),
                    imageUrl: imageUrl,
                    name: name,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 8);
                },
              );
            }),
      ),
    );
  }
}

class _CarouselItem extends StatelessWidget {
  const _CarouselItem({
    super.key,
    required this.imageUrl,
    required this.name,
  });

  final String imageUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    final searchManager = di<SearchManager>();
    final selected = searchManager.selectedContinent == null ||
        searchManager.selectedContinent == name;
    return SizedBox(
      width: 140,
      height: 140,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              errorListener: imageErrorListener,
              errorWidget: (context, url, error) {
                // NOTE: Getting "invalid image data" error for some of the images
                // e.g. https://rstr.in/google/tripedia/jlbgFDrSUVE
                return const DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.grey3,
                  ),
                  child: SizedBox(width: 140, height: 140),
                );
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white1,
                  ),
                ),
              ),
            ),
            // Overlay when other continent is selected
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: selected ? 0 : 0.7,
                duration: kThemeChangeDuration,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    // Support dark-mode
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            // Handle taps
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (searchManager.selectedContinent == name) {
                      searchManager.selectedContinent = null;
                    } else {
                      searchManager.selectedContinent = name;
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
