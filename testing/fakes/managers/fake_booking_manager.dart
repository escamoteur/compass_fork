// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/booking/_manager/booking_manager_.dart';
import 'package:compass_app/_features/booking/_model/booking.dart';
import 'package:compass_app/_features/booking/_model/booking_summary.dart';
import 'package:compass_app/_features/search/_model/destination.dart';
import 'package:flutter/foundation.dart';

import '../../models/destination.dart';

class FakeBookingManager extends BookingManager {
  final List<Booking> bookings = List.empty(growable: true);
  int sequentialId = 0;

  @override
  Future<void> createBooking(Booking booking) async {
    final bookingWithId = booking.copyWith(id: sequentialId++);
    bookings.add(bookingWithId);
  }

  @override
  Future<Booking> getBooking(int id) async {
    return bookings[id];
  }

  @override
  Future<List<BookingSummary>> getBookingsList() async {
    return _createSummaries();
  }

  List<BookingSummary> _createSummaries() {
    return bookings
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

  @override
  Future<void> deleteBooking(int id) async {
    bookings.removeWhere((booking) => booking.id == id);
  }

  @override
  Future<List<Destination>> getDestinations() {
    return SynchronousFuture([kDestination1, kDestination2]);
  }
}
