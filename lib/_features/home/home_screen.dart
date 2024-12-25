// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:go_router/go_router.dart';
import 'package:watch_it/watch_it.dart';

import '../../_shared/ui/localization/applocalization.dart';
import '../../_shared/ui/themes/dimens.dart';
import '../../_shared/ui/ui/date_format_start_end.dart';
import '../../_shared/ui/ui/error_indicator.dart';
import '../../routing/routes.dart';
import '../booking/_model/booking_summary.dart';
import '../booking/_manager/booking_manager_.dart';
import 'home_title.dart';

const String bookingButtonKey = 'booking-button';

class HomeScreen extends WatchingWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    registerHandler(
        select: (BookingManager bookingManager) =>
            bookingManager.deleteBookingCommand.results,
        handler: (context, result, _) {
          _onResult(context, result.hasData);
        });

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        // Workaround for https://github.com/flutter/flutter/issues/115358#issuecomment-2117157419
        heroTag: null,
        key: const ValueKey(bookingButtonKey),
        onPressed: () => context.go(Routes.search),
        label: Text(AppLocalization.of(context).bookNewTrip),
        icon: const Icon(Icons.add_location_outlined),
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: CommandBuilder(
          command: di<BookingManager>().loadBookingsCommand,
          whileExecuting: (context, _, __) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          onError: (context, error, _, __) {
            return ErrorIndicator(
              title: AppLocalization.of(context).errorWhileLoadingHome,
              label: AppLocalization.of(context).tryAgain,
              onPressed: di<BookingManager>().loadBookingsCommand.execute,
            );
          },
          onData: (context, bookings, _) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimens.of(context).paddingScreenVertical,
                    horizontal: Dimens.of(context).paddingScreenHorizontal,
                  ),
                  child: HomeHeader(),
                ),
              ),
              SliverList.builder(
                itemCount: bookings.length,
                itemBuilder: (_, index) => _Booking(
                  key: ValueKey(bookings[index].id),
                  booking: bookings[index],
                  onTap: () =>
                      context.push(Routes.bookingWithId(bookings[index].id)),
                  confirmDismiss: (_) async {
                    try {
                      // wait for command to complete
                      await di<BookingManager>()
                          .deleteBookingCommand
                          .executeWithFuture(bookings[index].id);
                      // if command completed successfully, return true
                      // removes the dismissable from the list
                      return true;
                    } catch (e) {
                      // the dismissable stays in the list
                      return false;
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onResult(BuildContext context, bool success) {
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalization.of(context).bookingDeleted),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalization.of(context).errorWhileDeletingBooking),
        ),
      );
    }
  }
}

class _Booking extends StatelessWidget {
  const _Booking({
    super.key,
    required this.booking,
    required this.onTap,
    required this.confirmDismiss,
  });

  final BookingSummary booking;
  final GestureTapCallback onTap;
  final ConfirmDismissCallback confirmDismiss;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(booking.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: confirmDismiss,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.of(context).paddingScreenHorizontal,
            vertical: Dimens.paddingVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                dateFormatStartEnd(
                  DateTimeRange(
                    start: booking.startDate,
                    end: booking.endDate,
                  ),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
