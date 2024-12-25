// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:watch_it/watch_it.dart';

import '_shared/ui/localization/applocalization.dart';
import '_shared/ui/themes/theme.dart';
import 'routing/router.dart';
import 'package:flutter/material.dart';

import '_shared/ui/ui/scroll_behavior.dart';
import 'main_development.dart' as development;

/// Default main method
void main() {
  // Launch development config by default
  development.main();
}

class MainApp extends WatchingWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// Wait for all dependencies to be ready
    if (allReady()) {
      return MaterialApp.router(
        localizationsDelegates: [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          AppLocalizationDelegate(),
        ],
        scrollBehavior: AppCustomScrollBehavior(),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: router(),
      );
    } else {
      return MaterialApp(
        home: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
