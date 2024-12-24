// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../_features/activities/_managers/activity_manager_.dart';
import '../_features/activities/_managers/activity_manager_local.dart';
import '../_features/activities/_managers/activity_manager_remote.dart';
import '../_features/auth/_managers/auth_manager_.dart';
import '../_features/auth/_managers/auth_manager_dev.dart';
import '../_features/auth/_managers/auth_manager_remote.dart';
import '../_features/auth/_managers/user_repository.dart';
import '../_features/auth/_managers/user_repository_local.dart';
import '../_features/auth/_managers/user_repository_remote.dart';
import '../_features/booking/_repo/booking_manager_.dart';
import '../_features/booking/_repo/booking_manager_local.dart';
import '../_features/booking/_repo/booking_manager_remote.dart';
import '../_features/booking/_repo/destination_repository.dart';
import '../_features/booking/_repo/destination_repository_local.dart';
import '../_features/booking/_repo/destination_repository_remote.dart';
import '../_features/booking/booking_create_use_case.dart';
import '../_features/booking/booking_share_use_case.dart';
import '../_features/search/_repo/continent_repository.dart';
import '../_features/search/_repo/continent_repository_local.dart';
import '../_features/search/_repo/continent_repository_remote.dart';
import '../_shared/itinerary_config/__manager/itinerary_config_manager_.dart';
import '../_shared/itinerary_config/__manager/itinerary_config_manager_memory.dart';
import '../_shared/services/api/api_client.dart';
import '../_shared/services/api/auth_api_client.dart';
import '../_shared/services/local/local_data_service.dart';
import '../_shared/services/shared_preferences_service.dart';

/// Shared providers for all configurations.
List<SingleChildWidget> _sharedProviders = [
  Provider(
    lazy: true,
    create: (context) => BookingCreateUseCase(
      destinationRepository: context.read(),
      activityRepository: context.read(),
      bookingRepository: context.read(),
    ),
  ),
  Provider(
    lazy: true,
    create: (context) => BookingShareUseCase.withSharePlus(),
  ),
];

/// Configure dependencies for remote data.
/// This dependency list uses repositories that connect to a remote server.
List<SingleChildWidget> get providersRemote {
  return [
    Provider(
      create: (context) => AuthApiClient(),
    ),
    Provider(
      create: (context) => ApiClient(),
    ),
    Provider(
      create: (context) => SharedPreferencesService(),
    ),
    ChangeNotifierProvider(
      create: (context) => AuthManagerRemote(
        authApiClient: context.read(),
        apiClient: context.read(),
        sharedPreferencesService: context.read(),
      ) as AuthManager,
    ),
    Provider(
      create: (context) => DestinationRepositoryRemote(
        apiClient: context.read(),
      ) as DestinationRepository,
    ),
    Provider(
      create: (context) => ContinentRepositoryRemote(
        apiClient: context.read(),
      ) as ContinentRepository,
    ),
    Provider(
      create: (context) => ActivitManagerRemote(
        apiClient: context.read(),
      ) as ActivityManager,
    ),
    Provider.value(
      value: ItineraryConfigManagerMemory() as ItineraryConfigManager,
    ),
    Provider(
      create: (context) => BookingManagerRemote(
        apiClient: context.read(),
      ) as BookingManager,
    ),
    Provider(
      create: (context) => UserRepositoryRemote(
        apiClient: context.read(),
      ) as UserRepository,
    ),
    ..._sharedProviders,
  ];
}

/// Configure dependencies for local data.
/// This dependency list uses repositories that provide local data.
/// The user is always logged in.
List<SingleChildWidget> get providersLocal {
  return [
    ChangeNotifierProvider.value(
      value: AuthManagerDev() as AuthManager,
    ),
    Provider.value(
      value: LocalDataService(),
    ),
    Provider(
      create: (context) => DestinationRepositoryLocal(
        localDataService: context.read(),
      ) as DestinationRepository,
    ),
    Provider(
      create: (context) => ContinentRepositoryLocal(
        localDataService: context.read(),
      ) as ContinentRepository,
    ),
    Provider(
      create: (context) => ActivityManagerLocal(
        localDataService: context.read(),
      ) as ActivityManager,
    ),
    Provider(
      create: (context) => BookingManagerLocal(
        localDataService: context.read(),
      ) as BookingManager,
    ),
    Provider.value(
      value: ItineraryConfigManagerMemory() as ItineraryConfigManager,
    ),
    Provider(
      create: (context) => UserRepositoryLocal(
        localDataService: context.read(),
      ) as UserRepository,
    ),
    ..._sharedProviders,
  ];
}
