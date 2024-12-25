// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/activities/_model/activity.dart';
import 'package:compass_app/_features/search/_model/continent.dart';
import 'package:compass_app/_features/search/_model/destination.dart';
import 'package:compass_app/_shared/services/api/api_client.dart';
import 'package:compass_app/_shared/services/api/model/booking/booking_api_model.dart';
import 'package:compass_app/_shared/services/api/model/login_request/login_request.dart';
import 'package:compass_app/_shared/services/api/model/login_response/login_response.dart';
import 'package:compass_app/_shared/services/api/model/user/user_api_model.dart';
import 'package:http/src/response.dart';

import '../../models/activity.dart';
import '../../models/booking.dart';
import '../../models/user.dart';

class FakeApiClient extends ApiClient {
  // Should not increase when using cached data
  int requestCount = 0;

  @override
  Future<List<Continent>> getContinents() async {
    requestCount++;
    return [
      const Continent(name: 'CONTINENT', imageUrl: 'URL'),
      const Continent(name: 'CONTINENT2', imageUrl: 'URL'),
    ];
  }

  @override
  Future<List<Destination>> getDestinations() async {
    requestCount++;
    return [
      const Destination(
        ref: 'ref1',
        name: 'name1',
        country: 'country1',
        continent: 'Europe',
        knownFor: 'knownFor1',
        tags: ['tags1'],
        imageUrl: 'imageUrl1',
      ),
      const Destination(
        ref: 'ref2',
        name: 'name2',
        country: 'country2',
        continent: 'Europe',
        knownFor: 'knownFor2',
        tags: ['tags2'],
        imageUrl: 'imageUrl2',
      ),
    ];
  }

  @override
  Future<List<Activity>> getActivityByDestination(String ref) async {
    requestCount++;

    if (ref == 'alaska') {
      return [
        const Activity(
          name: 'Glacier Trekking and Ice Climbing',
          description:
              'Embark on a thrilling adventure exploring the awe-inspiring glaciers of Alaska. Hike across the icy terrain, marvel at the deep blue crevasses, and even try your hand at ice climbing for an unforgettable experience.',
          locationName: 'Matanuska Glacier or Mendenhall Glacier',
          duration: 8,
          timeOfDay: TimeOfDay.morning,
          familyFriendly: false,
          price: 4,
          destinationRef: 'alaska',
          ref: 'glacier-trekking-and-ice-climbing',
          imageUrl:
              'https://storage.googleapis.com/tripedia-images/activities/alaska_glacier-trekking-and-ice-climbing.jpg',
        ),
      ];
    }

    if (ref == kBooking.destination.ref) {
      return [kActivity];
    }

    return [];
  }

  @override
  Future<BookingApiModel> getBooking(int id) async {
    return kBookingApiModel;
  }

  @override
  Future<List<BookingApiModel>> getBookings() async {
    return [kBookingApiModel];
  }

  List<BookingApiModel> bookings = [];

  @override
  Future<BookingApiModel> postBooking(BookingApiModel booking) async {
    final bookingWithId = booking.copyWith(id: bookings.length);
    bookings.add(bookingWithId);
    return bookingWithId;
  }

  @override
  Future<UserApiModel> getUser() async {
    return userApiModel;
  }

  @override
  Future<void> deleteBooking(int id) async {
    bookings.removeWhere((booking) => booking.id == id);
  }

  @override
  Future<Response> delete(String path) {
    throw UnimplementedError();
  }

  @override
  Future<Response> get(String path) {
    throw UnimplementedError();
  }

  @override
  Future<Response> post(String path, body) {
    throw UnimplementedError();
  }

  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    throw UnimplementedError();
  }
}
