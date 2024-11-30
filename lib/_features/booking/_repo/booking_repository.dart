// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../_model/booking.dart';
import '../_model/booking_summary.dart';
import '../../../_shared/utils/result.dart';

abstract class BookingRepository {
  /// Returns the list of [BookingSummary] for the current user.
  Future<Result<List<BookingSummary>>> getBookingsList();

  /// Returns a full [Booking] given the id.
  Future<Result<Booking>> getBooking(int id);

  /// Creates a new [Booking].
  Future<Result<void>> createBooking(Booking booking);

  /// Delete booking
  Future<Result<void>> delete(int id);
}