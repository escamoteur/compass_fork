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

class BookingRepositoryRemote extends BookingManager {
  BookingRepositoryRemote(
      {
      //you and inject the apiClient for testing her otherwise it will use the default one
      ApiClient? apiClient,
      required super.share})
      : _apiClient = apiClient ?? di<ApiClient>();

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
    return _apiClient.postBooking(bookingApiModel);
  }

  @override
  Future<Booking> getBooking(int id) async {
    // Get booking by ID from server
    final resultBooking = await _apiClient.getBooking(id);
    final booking = resultBooking.asOk.value;

    // Load destinations if not loaded yet
    if (_cachedDestinations == null) {
      final resultDestination = await _apiClient.getDestinations();
      _cachedDestinations = resultDestination.asOk.value;
    }

    // Get destination for booking
    final destination = _cachedDestinations!
        .firstWhere((destination) => destination.ref == booking.destinationRef);

    final resultActivities =
        await _apiClient.getActivityByDestination(destination.ref);

    final activities = resultActivities.asOk.value
        .where((activity) => booking.activitiesRef.contains(activity.ref))
        .toList();

    return Booking(
      id: booking.id,
      startDate: booking.startDate,
      endDate: booking.endDate,
      destination: destination,
      activity: activities,
    );
  }

  @override
  Future<List<BookingSummary>> getBookingsList() async {
    final result = await _apiClient.getBookings();
    final bookingsApi = result.asOk.value;
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
  Future<void> delete(int id) async {
    return _apiClient.deleteBooking(id);
  }

  List<Destination>? _cachedData;

  @override
  Future<List<Destination>> getDestinations() async {
    if (_cachedData == null) {
      // No cached data, request destinations
      final result = await _apiClient.getDestinations();
      _cachedData = result;
      return result;
    } else {
      // Return cached data if available
      return _cachedData!;
    }
  }
}
