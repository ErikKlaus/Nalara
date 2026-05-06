import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/radius/app_radius.dart';
import '../../../../core/spacing/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class ConfidenceBadge extends StatelessWidget {
  final String confidence;
  final String? reason;

  const ConfidenceBadge({super.key, required this.confidence, this.reason});

  Color _badgeColor() {
    switch (confidence) {
      case 'tinggi':
        return AppColors.success;
      case 'sedang':
        return AppColors.warning;
      case 'rendah':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _badgeColor();
    final l10n = AppLocalizations.of(context)!;
    final label = switch (confidence) {
      'tinggi' => l10n.confidenceHigh,
      'sedang' => l10n.confidenceMedium,
      'rendah' => l10n.confidenceLow,
      _ => l10n.confidenceMedium,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.full,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (reason != null && reason!.isNotEmpty) ...[
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                reason!,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
