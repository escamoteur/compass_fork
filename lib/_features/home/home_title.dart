// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watch_it/watch_it.dart';

import '../../_shared/ui/localization/applocalization.dart';
import '../../_shared/ui/themes/dimens.dart';
import '../auth/_managers/auth_manager_.dart';
import '../auth/logout/widgets/logout_button.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = di<AuthManager>().getCurrentUserCommand.value;

    if (user == null) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Image.asset(
                user.picture,
                width: Dimens.of(context).profilePictureSize,
                height: Dimens.of(context).profilePictureSize,
              ),
            ),
            LogoutButton(),
          ],
        ),
        const SizedBox(height: Dimens.paddingVertical),
        _Title(
          text: AppLocalization.of(context).nameTrips(user.name),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => RadialGradient(
        center: Alignment.bottomLeft,
        radius: 2,
        colors: [
          Colors.purple.shade700,
          Colors.purple.shade400,
        ],
      ).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: GoogleFonts.rubik(
          textStyle: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
