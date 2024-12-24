import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../_shared/ui/localization/applocalization.dart';
import '../../../_shared/ui/themes/dimens.dart';
import '../../../_shared/ui/ui/error_indicator.dart';
import '../_managers/activity_manager_.dart';
import 'activities_header.dart';
import 'activities_list.dart';
import 'activities_title.dart';

const String confirmButtonKey = 'confirm-button';

class ActivitiesBody extends WatchingWidget {
  const ActivitiesBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading =
        watchValue((ActivityManager m) => m.loadActivitiesCommand.isExecuting);
    final hasError =
        watchValue((ActivityManager m) => m.loadActivitiesCommand.errors) !=
            null;

    return Column(
      children: [
        const ActivitiesHeader(),
        if (isLoading)
          const Expanded(child: Center(child: CircularProgressIndicator())),
        if (hasError)
          Expanded(
            child: Center(
              child: ErrorIndicator(
                title: AppLocalization.of(context).errorWhileLoadingActivities,
                label: AppLocalization.of(context).tryAgain,
                onPressed: di<ActivityManager>().loadActivitiesCommand.execute,
              ),
            ),
          ),
        if (!isLoading && !hasError)
          Expanded(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: ActivitiesHeader(),
                ),
                if (di<ActivityManager>().daytimeActivities.isNotEmpty) ...[
                  ActivitiesTitle(
                    title: AppLocalization.of(context).daytime,
                  ),
                  ActivitiesList(
                    activities: di<ActivityManager>().daytimeActivities,
                  ),
                ],
                if (di<ActivityManager>().eveningActivities.isNotEmpty) ...[
                  ActivitiesTitle(
                    title: AppLocalization.of(context).evening,
                  ),
                  ActivitiesList(
                    activities: di<ActivityManager>().eveningActivities,
                  ),
                ],
              ],
            ),
          ),
        _BottomArea(),
      ],
    );
  }
}

class _BottomArea extends WatchingWidget {
  const _BottomArea();

  @override
  Widget build(BuildContext context) {
    registerHandler(
        select: (ActivityManager m) => m.saveActivitiesCommand.errors,
        handler: (context, error, __) {
          if (error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    AppLocalization.of(context).errorWhileSavingActivities),
                action: SnackBarAction(
                  label: AppLocalization.of(context).tryAgain,
                  onPressed:
                      di<ActivityManager>().saveActivitiesCommand.execute,
                ),
              ),
            );
          }
        });

    return SafeArea(
      bottom: true,
      child: Material(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.only(
            left: Dimens.of(context).paddingScreenHorizontal,
            right: Dimens.of(context).paddingScreenVertical,
            top: Dimens.paddingVertical,
            bottom: Dimens.of(context).paddingScreenVertical,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalization.of(context)
                    .selected(di<ActivityManager>().selectedActivities.length),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              FilledButton(
                key: const Key(confirmButtonKey),
                onPressed: di<ActivityManager>().selectedActivities.isNotEmpty
                    ? di<ActivityManager>().saveActivitiesCommand.execute
                    : null,
                child: Text(AppLocalization.of(context).confirm),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
