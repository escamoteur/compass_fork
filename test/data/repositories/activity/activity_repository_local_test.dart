// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/activities/_managers/activity_manager_local.dart';
import 'package:compass_app/_shared/services/local/local_data_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivityRepositoryLocal tests', () {
    // To load assets
    TestWidgetsFlutterBinding.ensureInitialized();

    final repository = ActivityManagerLocal(
      localDataService: LocalDataService(),
    );

    test('should get by destination ref', () async {
      final result = await repository.getByDestination('alaska');

      expect(result.length, 20);

      final activity = result.first;
      expect(activity.name, 'Glacier Trekking and Ice Climbing');
    });
  });
}
