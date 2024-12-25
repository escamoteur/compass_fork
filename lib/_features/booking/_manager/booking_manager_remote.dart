// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:watch_it/watch_it.dart';

import '../../../_shared/services/api/api_client.dart';
import '../../../_shared/services/api/model/booking/booking_api_model.dart';
import '../../search/_model/destination.dart';
import '../_model/booking.dart';
import '../_model/booking_summary.dart';
import 'booking_manager_.dart';

class BookingManagerRemote extends BookingManager {
  BookingManagerRemote({
    //you and inject the apiClient for testing her otherwise it will use the default one
    ApiClient? apiClient,
  }) : _apiClient = apiClient ?? di<ApiClient>();

  final ApiClient _apiClient;

  List<Destination>? _cachedDestinations;

  @override
  Future<void> createBooking(Booking booking) async {
    final BookingApiModel bookingApiModel = BookingApiModel(
      startDate: booking.startDate,
      endDate: booking.endDate,
      name: '${booking.destination.name}, ${booking.destination.continent}',
      destinationRef: booking.destination.ref,
      activitiesRef: booking.activity.map((activity) => activity.ref).toList(),
    );
    await _apiClient.postBooking(bookingApiModel);
  }

  @override
  Future<Booking> getBooking(int id) async {
    // Get booking by ID from server
    final booking = await _apiClient.getBooking(id);

    // Load destinations if not loaded yet
    _cachedDestinations ??= await _apiClient.getDestinations();

    // Get destination for booking
    final destination = _cachedDestinations!
        .firstWhere((destination) => destination.ref == booking.destinationRef);

    final activities =
        await _apiClient.getActivityByDestination(destination.ref);
    final filteredActivities = activities
        .where((activity) => booking.activitiesRef.contains(activity.ref))
        .toList();

    return Booking(
      id: booking.id,
      startDate: booking.startDate,
      endDate: booking.endDate,
      destination: destination,
      activity: filteredActivities,
    );
  }

  @override
  Future<List<BookingSummary>> getBookingsList() async {
    final bookingsApi = await _apiClient.getBookings();
    return bookingsApi
        .map(
          (bookingApi) => BookingSummary(
            id: bookingApi.id!,
            name: bookingApi.name,
            startDate: bookingApi.startDate,
            endDate: bookingApi.endDate,
          ),
        )
        .toList();
  }

  @override
  Future<void> deleteBooking(int id) async {
    await _apiClient.deleteBooking(id);
  }

  List<Destination>? _cachedData;

  @override
  Future<List<Destination>> getDestinations() async {
    if (_cachedData == null) {
      // No cached data, request destinations
      _cachedData = await _apiClient.getDestinations();
      return _cachedData!;
    } else {
      // Return cached data if available
      return _cachedData!;
    }
  }
}
