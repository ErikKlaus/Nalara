import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/radius/app_radius.dart';
import '../../../../core/spacing/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/scenario_entity.dart';

class ScenarioCard extends StatelessWidget {
  final ScenarioEntity scenario;

  const ScenarioCard({super.key, required this.scenario});

  Color _likelihoodColor() {
    switch (scenario.likelihood) {
      case 'tinggi':
        return AppColors.error;
      case 'sedang':
        return AppColors.warning;
      case 'rendah':
        return AppColors.success;
      default:
        return AppColors.info;
    }
  }

  String _likelihoodLabel(AppLocalizations l10n) {
    switch (scenario.likelihood) {
      case 'tinggi':
        return l10n.likelihoodHigh.toUpperCase();
      case 'sedang':
        return l10n.likelihoodMedium.toUpperCase();
      case 'rendah':
        return l10n.likelihoodLow.toUpperCase();
      default:
        return scenario.likelihood.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final likelihoodColor = _likelihoodColor();

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    scenario.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.micro,
                  ),
                  decoration: BoxDecoration(
                    color: likelihoodColor.withValues(alpha: 0.12),
                    borderRadius: AppRadius.full,
                  ),
                  child: Text(
                    _likelihoodLabel(l10n),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: likelihoodColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              scenario.narrative,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${l10n.analysisRootCauseLabel}:',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.micro),
            Text(
              scenario.mainCause,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
