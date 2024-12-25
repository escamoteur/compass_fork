// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/ui/localization/applocalization.dart';
import '../../../_shared/ui/themes/dimens.dart';
import '../../../_shared/ui/ui/error_indicator.dart';
import '../../../_shared/utils/image_error_listener.dart';
import '../../../routing/routes.dart';
import '../../activities/_model/activity.dart';
import '../_manager/booking_manager_.dart';
import 'booking_header.dart';

class BookingBody extends WatchingWidget {
  const BookingBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isBusy =
        watchValue((BookingManager bookingManager) => bookingManager.isBusy);
    final creationError = watchValue((BookingManager bookingManager) =>
        bookingManager.createBookingCommand.errors);
    final loadError = watchValue((BookingManager bookingManager) =>
        bookingManager.loadBookingCommand.errors);
    if (isBusy) {
      const Center(
        child: CircularProgressIndicator(),
      );
    }
    final booking =
        watchValue((BookingManager bookingManager) => bookingManager.booking);

    // If fails to create booking, tap to try again
    if (creationError != null) {
      return Center(
        child: ErrorIndicator(
          title: AppLocalization.of(context).errorWhileLoadingBooking,
          label: AppLocalization.of(context).tryAgain,
          onPressed: di<BookingManager>().createBookingCommand.execute,
        ),
      );
    }
    // If existing booking fails to load, tap to go /home
    if (loadError != null) {
      return Center(
        child: ErrorIndicator(
          title: AppLocalization.of(context).errorWhileLoadingBooking,
          label: AppLocalization.of(context).close,
          onPressed: () => context.go(Routes.home),
        ),
      );
    }
    if (booking == null) return const SizedBox();
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: BookingHeader(booking: booking)),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final activity = booking.activity[index];
              return _Activity(activity: activity);
            },
            childCount: booking.activity.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 200)),
      ],
    );
  }
}

class _Activity extends StatelessWidget {
  const _Activity({
    required this.activity,
  });

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimens.paddingVertical,
        left: Dimens.of(context).paddingScreenHorizontal,
        right: Dimens.of(context).paddingScreenHorizontal,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: activity.imageUrl,
              height: 80,
              width: 80,
              errorListener: imageErrorListener,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  activity.timeOfDay.name.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  activity.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  activity.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
