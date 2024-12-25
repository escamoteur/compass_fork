// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:go_router/go_router.dart';
import 'package:watch_it/watch_it.dart';

import '../../_shared/itinerary_config/__manager/itinerary_config_manager_.dart';
import '../../_shared/itinerary_config/itinerary_config.dart';
import '../../_shared/ui/localization/applocalization.dart';
import '../../_shared/ui/themes/dimens.dart';
import '../../_shared/ui/ui/error_indicator.dart';
import '../../_shared/ui/ui/search_bar.dart';
import '../../routing/routes.dart';
import '../booking/_manager/booking_manager_.dart';
import '../search/_model/destination.dart';
import 'result_card.dart';

class ResultsScreen extends WatchingStatefulWidget {
  const ResultsScreen({
    super.key,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late final _loadDataCommand = Command.createAsyncNoParam<
      ({ItineraryConfig config, List<Destination> destinations})?>(
    () async {
      final config = await di<ItineraryConfigManager>().getItineraryConfig();
      final destinations = await di<BookingManager>().getDestinations();
      return (config: config, destinations: destinations);
    },
    initialValue: null,
  );

  late final _updateItineraryConfigWithDestinationsCommand =
      Command.createAsyncNoResult<String>(
    (destinationRef) async {
      final config = await di<ItineraryConfigManager>().getItineraryConfig();
      await di<ItineraryConfigManager>().setItineraryConfig(config.copyWith(
        destination: destinationRef,
      ));
    },
  );

  @override
  void initState() {
    super.initState();
    _loadDataCommand.execute();
  }

  @override
  void dispose() {
    _loadDataCommand.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    registerHandler(
        target: _updateItineraryConfigWithDestinationsCommand,
        handler: (context, newValue, cancel) => context.go(Routes.activities));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, r) {
        if (!didPop) context.go(Routes.search);
      },
      child: Scaffold(
        body: CommandBuilder(
          command: _loadDataCommand,
          whileExecuting: (context, lastValue, _) => Column(
            children: [
              _AppSearchBar(
                  config: lastValue?.config ?? const ItineraryConfig()),
              const Expanded(child: Center(child: CircularProgressIndicator())),
            ],
          ),
          onError: (context, error, lastValue, __) => Column(
            children: [
              _AppSearchBar(
                  config: lastValue?.config ?? const ItineraryConfig()),
              Expanded(
                child: Center(
                  child: ErrorIndicator(
                    title: AppLocalization.of(context)
                        .errorWhileLoadingDestinations,
                    label: AppLocalization.of(context).tryAgain,
                    onPressed: _loadDataCommand.execute,
                  ),
                ),
              ),
            ],
          ),
          onData: (context, data, _) => Padding(
            padding: Dimens.of(context).edgeInsetsScreenHorizontal,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _AppSearchBar(config: data!.config),
                ),
                _Grid(
                  destinations: data!.destinations,
                  updateItineraryConfigCommand:
                      _updateItineraryConfigWithDestinationsCommand,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppSearchBar extends StatelessWidget {
  const _AppSearchBar({
    required this.config,
  });

  final ItineraryConfig config;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(
          top: Dimens.of(context).paddingScreenVertical,
          bottom: Dimens.dimensMobile.paddingScreenVertical,
        ),
        child: AppSearchBar(
          config: config,
          onTap: () {
            // Navigate to SearchFormScreen and edit search
            context.pop();
          },
        ),
      ),
    );
  }
}

class _Grid extends WatchingWidget {
  const _Grid({
    required this.destinations,
    required this.updateItineraryConfigCommand,
  });

  final List<Destination> destinations;
  final Command<String, void> updateItineraryConfigCommand;

  @override
  Widget build(BuildContext context) {
    registerHandler(
      target: updateItineraryConfigCommand.errors,
      handler: (context, _, __) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalization.of(context).errorWhileSavingItinerary),
        ),
      ),
    );
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 182 / 222,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final destination = destinations[index];
          return ResultCard(
            key: ValueKey(destination.ref),
            destination: destination,
            onTap: () {
              updateItineraryConfigCommand.execute(destination.ref);
            },
          );
        },
        childCount: destinations.length,
      ),
    );
  }
}
