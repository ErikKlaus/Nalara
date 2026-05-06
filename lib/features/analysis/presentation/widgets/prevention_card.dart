import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/radius/app_radius.dart';
import '../../../../core/spacing/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/scenario_entity.dart';

class PreventionCard extends StatelessWidget {
  final List<PreventionActionEntity> actions;

  const PreventionCard({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.preventiveActionsTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final action in actions)
              Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                padding: AppSpacing.card,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: AppRadius.large,
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.action,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        label: Text(action.timing),
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.12,
                        ),
                        labelStyle: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
