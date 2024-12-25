// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:watch_it/watch_it.dart';

import '../_features/activities/widgets/activities_screen.dart';
import '../_features/auth/_managers/auth_manager_.dart';
import '../_features/auth/login/widgets/login_screen.dart';
import '../_features/booking/_manager/booking_manager_.dart';
import '../_features/booking/widgets/booking_screen.dart';
import '../_features/home/home_screen.dart';
import '../_features/results/results_screen.dart';
import '../_features/search/widgets/search_form_screen.dart';
import 'routes.dart';

/// Top go_router entry point.
///
/// Listens to changes in [AuthTokenRepository] to redirect the user
/// to /login when the user logs out.

GoRouter router() => GoRouter(
      initialLocation: Routes.home,
      debugLogDiagnostics: true,
      redirect: _redirect,
      refreshListenable: di.get<AuthManager>(),
      routes: [
        GoRoute(
          path: Routes.login,
          builder: (context, state) {
            return LoginScreen();
          },
        ),
        GoRoute(
          path: Routes.home,
          builder: (context, state) {
            return HomeScreen();
          },
          routes: [
            GoRoute(
              path: Routes.searchRelative,
              builder: (context, state) {
                return SearchFormScreen();
              },
            ),
            GoRoute(
              path: Routes.resultsRelative,
              builder: (context, state) {
                return ResultsScreen();
              },
            ),
            GoRoute(
              path: Routes.activitiesRelative,
              builder: (context, state) {
                return ActivitiesScreen();
              },
            ),
            GoRoute(
              path: Routes.bookingRelative,
              builder: (context, state) {
                // When opening the booking screen directly
                // create a new booking from the stored ItineraryConfig.
                di<BookingManager>().createBookingCommand.execute();
                return BookingScreen();
              },
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final id = int.parse(state.pathParameters['id']!);

                    // When opening the booking screen with an existing id
                    // load and display that booking.
                    di<BookingManager>().loadBookingCommand.execute(id);

                    return BookingScreen();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );

// From https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart
Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  // if the user is not logged in, they need to login
  final bool loggedIn = di.get<AuthManager>().isAuthenticated;
  final bool loggingIn = state.matchedLocation == Routes.login;
  if (!loggedIn) {
    return Routes.login;
  }

  // if the user is logged in but still on the login page, send them to
  // the home page
  if (loggingIn) {
    return Routes.home;
  }

  // no need to redirect at all
  return null;
}
