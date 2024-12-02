// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/ui/localization/applocalization.dart';
import '../../../routing/routes.dart';
import '../_repo/booking_manager_.dart';
import 'booking_body.dart';

class BookingScreen extends WatchingWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentBooking =
        watchValue((BookingManager bookingManager) => bookingManager.booking);

    registerHandler(
      select: (BookingManager bookingManager) {
        return bookingManager.shareBookingCommand.errors;
      },
      handler: (context, result, _) =>
          ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalization.of(context).errorWhileSharing),
          action: SnackBarAction(
            label: AppLocalization.of(context).tryAgain,
            onPressed: di<BookingManager>().shareBookingCommand.execute,
          ),
        ),
      ),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, r) {
        // Back navigation always goes to home
        if (!didPop) context.go(Routes.home);
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          // Workaround for https://github.com/flutter/flutter/issues/115358#issuecomment-2117157419
          heroTag: null,
          key: const ValueKey('share-button'),
          onPressed: currentBooking != null
              ? di<BookingManager>().shareBookingCommand.execute
              : null,
          label: Text(AppLocalization.of(context).shareTrip),
          icon: const Icon(Icons.share_outlined),
        ),
        body: BookingBody(),
      ),
    );
  }
}
