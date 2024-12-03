// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:collection/collection.dart';

import '../../../_shared/services/local/local_data_service.dart';
import '../../search/_model/destination.dart';
import '../_model/booking.dart';
import '../_model/booking_summary.dart';
import 'booking_manager_.dart';

class BookingManagerLocal extends BookingManager {
  BookingManagerLocal({
    required LocalDataService localDataService,
    required super.share,
  }) : _localDataService = localDataService;

  // Only create default booking once
  bool _isInitialized = false;
  // Used to generate IDs for bookings
  int _sequentialId = 0;

  final _bookings = List<Booking>.empty(growable: true);
  final LocalDataService _localDataService;

  @override
  Future<void> createBooking(Booking booking) async {
    // Bookings created come without id, we need to assign one
    final bookingWithId = booking.copyWith(id: _sequentialId++);
    _bookings.add(bookingWithId);
  }

  @override
  Future<Booking> getBooking(int id) async {
    final booking = _bookings.firstWhereOrNull((booking) => booking.id == id);
    if (booking == null) {
      throw (Exception('Booking not found'));
    }
    return booking;
  }

  @override
  Future<List<BookingSummary>> getBookingsList() async {
    // Initialize the repository with a default booking
    if (!_isInitialized) {
      await _createDefaultBooking();
      _isInitialized = true;
    }

    return _createSummaries();
  }

  List<BookingSummary> _createSummaries() {
    return _bookings
        .map(
          (booking) => BookingSummary(
            id: booking.id!,
            name:
                '${booking.destination.name}, ${booking.destination.continent}',
            startDate: booking.startDate,
            endDate: booking.endDate,
          ),
        )
        .toList();
  }

  Future<void> _createDefaultBooking() async {
    // create a default booking the first time
    if (_bookings.isEmpty) {
      final destination = (await _localDataService.getDestinations()).first;
      final activities = (await _localDataService.getActivities())
          .where((activity) => activity.destinationRef == destination.ref)
          .take(4)
          .toList();

      _bookings.add(
        Booking(
          id: _sequentialId++,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 2, 1),
          destination: destination,
          activity: activities,
        ),
      );
    }
  }

  @override
  Future<void> deleteBooking(int id) async {
    _bookings.removeWhere((booking) => booking.id == id);
  }

  @override
  Future<List<Destination>> getDestinations() async {
    return await _localDataService.getDestinations();
  }
}
