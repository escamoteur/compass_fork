// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../_shared/utils/result.dart';
import '../../auth/_model/user.dart';
import '../../booking/_model/booking_summary.dart';
import '../../booking/_repo/booking_manager_.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required BookingManager bookingRepository,
    required UserRepository userRepository,
  })  : _bookingRepository = bookingRepository,
        _userRepository = userRepository {
    load = Command0(_load)..execute();
    deleteBooking = Command1(_deleteBooking);
  }

  final BookingManager _bookingRepository;
  final UserRepository _userRepository;
  final _log = Logger('HomeViewModel');
  List<BookingSummary> _bookings = [];
  UserProxy? _user;

  late Command0 load;
  late Command1<void, int> deleteBooking;

  List<BookingSummary> get bookings => _bookings;

  UserProxy? get user => _user;

  Future<Result> _load() async {
    try {
      final result = await _bookingRepository.getBookingsList();
      switch (result) {
        case Ok<List<BookingSummary>>():
          _bookings = result.value;
          _log.fine('Loaded bookings');
        case Error<List<BookingSummary>>():
          _log.warning('Failed to load bookings', result.error);
          return result;
      }

      final userResult = await _userRepository.getUser();
      switch (userResult) {
        case Ok<UserProxy>():
          _user = userResult.value;
          _log.fine('Loaded user');
        case Error<UserProxy>():
          _log.warning('Failed to load user', userResult.error);
      }

      return userResult;
    } finally {
      notifyListeners();
    }
  }

  Future<void>> _deleteBooking(int id) async {
    try {
      final resultDelete = await _bookingRepository.delete(id);
      switch (resultDelete) {
        case Ok<void>():
          _log.fine('Deleted booking $id');
        case Error<void>():
          _log.warning('Failed to delete booking $id', resultDelete.error);
          return resultDelete;
      }

      // After deleting the booking, we need to reload the bookings list.
      // BookingRepository is the source of truth for bookings.
      final resultLoadBookings = await _bookingRepository.getBookingsList();
      switch (resultLoadBookings) {
        case Ok<List<BookingSummary>>():
          _bookings = resultLoadBookings.value;
          _log.fine('Loaded bookings');
        case Error<List<BookingSummary>>():
          _log.warning('Failed to load bookings', resultLoadBookings.error);
          return resultLoadBookings;
      }

      return resultLoadBookings;
    } finally {
      notifyListeners();
    }
  }
}
