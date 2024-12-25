import 'package:watch_it/watch_it.dart';

import '../_features/activities/_managers/activity_manager_.dart';
import '../_features/activities/_managers/activity_manager_local.dart';
import '../_features/activities/_managers/activity_manager_remote.dart';
import '../_features/auth/_managers/auth_manager_.dart';
import '../_features/auth/_managers/auth_manager_dev.dart';
import '../_features/auth/_managers/auth_manager_remote.dart';
import '../_features/booking/_manager/booking_manager_.dart';
import '../_features/booking/_manager/booking_manager_local.dart';
import '../_features/booking/_manager/booking_manager_remote.dart';
import '../_features/search/_manager/search_manager_.dart';
import '../_features/search/_manager/search_manager_local.dart';
import '../_features/search/_manager/search_manager_remote.dart';
import '../_shared/itinerary_config/__manager/itinerary_config_manager_.dart';
import '../_shared/itinerary_config/__manager/itinerary_config_manager_memory.dart';
import '../_shared/services/api/api_client.dart';
import '../_shared/services/api/http_client_factory.dart';
import '../_shared/services/local/local_data_service.dart';
import '../_shared/services/share_service.dart';
import '../_shared/services/shared_preferences_service.dart';

void registerDependencies() {
  di.registerSingleton<ShareService>(ShareService.withSharePlus());
  di.registerSingleton<SharedPreferencesService>(SharedPreferencesService());
}

void registerLocalDependencies() {
  final localDataService = LocalDataService();
  di.registerSingleton<ActivityManager>(
      ActivityManagerLocal(localDataService: localDataService));
  di.registerSingleton<BookingManager>(
      BookingManagerLocal(localDataService: localDataService));
  di.registerSingleton<ItineraryConfigManager>(ItineraryConfigManagerMemory());
  di.registerSingleton<SearchManager>(
      SearchManagerLocal(localDataService: localDataService));

  di.registerSingletonAsync<AuthManager>(
      () => AuthManagerDev(localDataService: localDataService).init());
}

void registerRemoteDependencies() {
  di.registerSingleton<ApiClient>(ApiClient(clientFactory: httpClientFactory));
  di.registerSingleton<BookingManager>(BookingManagerRemote());
  di.registerSingleton<ActivityManager>(ActivitManagerRemote());
  di.registerSingleton<SearchManager>(SearchManagerRemote());
  di.registerSingletonAsync<AuthManager>(() => AuthManagerRemote().init());
}
