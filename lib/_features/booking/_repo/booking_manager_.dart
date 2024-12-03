// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:logging/logging.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/itinerary_config/__manager/itinerary_config_manager_.dart';
import '../../../_shared/itinerary_config/itinerary_config.dart';
import '../../../_shared/ui/ui/date_format_start_end.dart';
import '../../activities/_repo/activity_repository.dart';
import '../../search/_model/destination.dart';
import '../_model/booking.dart';
import '../_model/booking_summary.dart';

typedef ShareFunction = Future<void> Function(String text);

abstract class BookingManager {
  BookingManager({
    required ShareFunction share,
  }) : _share = share;

  late final ValueListenable<bool> isBusy =
      createBookingCommand.isExecuting.mergeWith(
    [loadBookingCommand.isExecuting, deleteBookingCommand.isExecuting],
  );

  final ShareFunction _share;
  final _log = Logger('BookingViewModel');

  late final Command<void, void> createBookingCommand =
      Command.createAsyncNoParamNoResult(() async {
    _log.fine('Loading booking');
    final itineraryConfig =
        await di<ItineraryConfigManager>().getItineraryConfig();
    _log.fine('Loaded stored ItineraryConfig');
    _booking.value = await createFrom(itineraryConfig);
    _log.fine('Created Booking');
  });

  /// Loads booking by id
  late final Command<int, void> loadBookingCommand =
      Command.createAsyncNoResult((id) async {
    _booking.value = await getBooking(id);
    _log.fine('Loaded booking $id');
  });

  late final Command<int, void> deleteBookingCommand =
      Command.createAsyncNoResult((id) async {
    await deleteBooking(id);
    _log.fine('Deleted booking $id');

    // After deleting the booking, we need to reload the bookings list.
    // BookingRepository is the source of truth for bookings.
    loadBookingsCommand.execute();
    _log.fine('Reloaded bookings after deletion');
  });

  List<BookingSummary> get bookings => loadBookingsCommand.value;

  late final Command<void, List<BookingSummary>> loadBookingsCommand =
      Command.createAsyncNoParam(
    () async {
      final bookings = await getBookingsList();
      _log.fine('Loaded bookings');
      return bookings;
    },
    initialValue: [],
  );

  /// Share the current booking using the OS share dialog.
  late final Command<void, void> shareBookingCommand =
      Command.createAsyncNoParamNoResult(
    () async {
      final text = 'Trip to ${_booking.value!.destination.name}\n'
          'on ${dateFormatStartEnd(DateTimeRange(start: _booking.value!.startDate, end: _booking.value!.endDate))}\n'
          'Activities:\n'
          '${_booking.value!.activity.map((a) => ' - ${a.name}').join('\n')}.';

      _log.info('Sharing booking: $text');
      try {
        await _share(text);
        _log.fine('Shared booking');
      } on Exception catch (error) {
        _log.severe('Failed to share booking', error);
        rethrow;
      }
    },
  );

  /// the current booking
  ValueListenable<Booking?> get booking => _booking;
  final ValueNotifier<Booking?> _booking = ValueNotifier(null);

  /// Create [Booking] from a stored [ItineraryConfig]
  Future<Booking> createFrom(ItineraryConfig itineraryConfig) async {
    // Get Destination object from repository
    if (itineraryConfig.destination == null) {
      _log.warning('Destination is not set');
      throw Exception('Destination is not set');
    }
    final destinationResult =
        await _fetchDestination(itineraryConfig.destination!);

    _log.fine('Destination loaded: $destinationResult');

    // Get Activity objects from repository
    if (itineraryConfig.activities.isEmpty) {
      _log.warning('Activities are not set');
      throw Exception('Activities are not set');
    }
    final activitiesResult = await di<ActivityRepository>().getByDestination(
      itineraryConfig.destination!,
    );

    final activities = activitiesResult
        .where(
          (activity) => itineraryConfig.activities.contains(activity.ref),
        )
        .toList();
    _log.fine('Activities loaded (${activities.length})');

    // Check if dates are set
    if (itineraryConfig.startDate == null || itineraryConfig.endDate == null) {
      _log.warning('Dates are not set');
      throw Exception('Dates are not set');
    }

    final booking = Booking(
      startDate: itineraryConfig.startDate!,
      endDate: itineraryConfig.endDate!,
      destination: destinationResult,
      activity: activities,
    );

    await createBooking(booking);

    // Create Booking object
    return booking;
  }

  Future<Destination> _fetchDestination(String destinationRef) async {
    final result = await getDestinations();
    final destination =
        result.firstWhere((destination) => destination.ref == destinationRef);
    return destination;
  }

  /// Returns the list of [BookingSummary] for the current user.
  Future<List<BookingSummary>> getBookingsList();

  /// Returns a full [Booking] given the id.
  Future<Booking> getBooking(int id);

  /// Creates a new [Booking].
  Future<void> createBooking(Booking booking);

  /// Delete booking
  Future<void> deleteBooking(int id);

  Future<List<Destination>> getDestinations();
}
