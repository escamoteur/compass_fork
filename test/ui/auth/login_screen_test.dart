// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/_features/auth/_managers/auth_manager_.dart';
import 'package:compass_app/_features/auth/login/widgets/login_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:watch_it/watch_it.dart';

import '../../../testing/app.dart';
import '../../../testing/fakes/managers/fake_auth_manager.dart';
import '../../../testing/mocks.dart';

void main() {
  group('LoginScreen test', () {
    late MockGoRouter goRouter;
    late FakeAuthManager fakeAuthRepository;

    setUp(() {
      fakeAuthRepository = FakeAuthManager();
      di.registerSingleton<AuthManager>(fakeAuthRepository);
      goRouter = MockGoRouter();
    });

    Future<void> loadScreen(WidgetTester tester) async {
      await testApp(
        tester,
        LoginScreen(),
        goRouter: goRouter,
      );
    }

    testWidgets('should load screen', (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await loadScreen(tester);
        expect(find.byType(LoginScreen), findsOneWidget);
      });
    });

    testWidgets('should perform login', (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await loadScreen(tester);

        // Repo should have no key
        expect(fakeAuthRepository.token, null);

        // Perform login
        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();

        // Repo should have key
        expect(fakeAuthRepository.token, 'TOKEN');

        // Should navigate to home screen
        verify(() => goRouter.go('/')).called(1);
      });
    });
  });
}
