// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../_features/activities/_model/activity.dart';
import '../../../_features/auth/_model/user.dart';
import '../../../_features/search/_model/continent.dart';
import '../../../_features/search/_model/destination.dart';
import '../../../config/assets.dart';
import '../api/model/user/user_api_model.dart';

class LocalDataService {
  List<Continent> getContinents() {
    return [
      const Continent(
        name: 'Europe',
        imageUrl: 'https://rstr.in/google/tripedia/TmR12QdlVTT',
      ),
      const Continent(
        name: 'Asia',
        imageUrl: 'https://rstr.in/google/tripedia/VJ8BXlQg8O1',
      ),
      const Continent(
        name: 'South America',
        imageUrl: 'https://rstr.in/google/tripedia/flm_-o1aI8e',
      ),
      const Continent(
        name: 'Africa',
        imageUrl: 'https://rstr.in/google/tripedia/-nzi8yFOBpF',
      ),
      const Continent(
        name: 'North America',
        imageUrl: 'https://rstr.in/google/tripedia/jlbgFDrSUVE',
      ),
      const Continent(
        name: 'Oceania',
        imageUrl: 'https://rstr.in/google/tripedia/vxyrDE-fZVL',
      ),
      const Continent(
        name: 'Australia',
        imageUrl: 'https://rstr.in/google/tripedia/z6vy6HeRyvZ',
      ),
    ];
  }

  Future<List<Activity>> getActivities() async {
    final json = await _loadStringAsset(Assets.activities);
    return json.map<Activity>((json) => Activity.fromJson(json)).toList();
  }

  Future<List<Destination>> getDestinations() async {
    final json = await _loadStringAsset(Assets.destinations);
    return json.map<Destination>((json) => Destination.fromJson(json)).toList();
  }

  Future<List<Map<String, dynamic>>> _loadStringAsset(String asset) async {
    final localData = await rootBundle.loadString(asset);
    return (jsonDecode(localData) as List).cast<Map<String, dynamic>>();
  }

  UserProxy getUser() {
    return UserProxy(
      UserApiModel(
        id: '1',
        email: 'sofie@tripedia.com',
        name: 'Sofie',
        // For demo purposes we use a local asset
        picture: 'assets/user.jpg',
      ),
    );
  }
}
