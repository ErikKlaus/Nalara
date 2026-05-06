import 'package:flutter/material.dart';

import '../../core/colors/app_colors.dart';
import '../../core/radius/app_radius.dart';
import '../../core/spacing/app_spacing.dart';

enum AppStatusTone { success, warning, error, info, neutral, primary }

class AppStatusChip extends StatelessWidget {
  final String label;
  final AppStatusTone tone;
  final IconData? icon;

  const AppStatusChip({
    super.key,
    required this.label,
    this.tone = AppStatusTone.neutral,
    this.icon,
  });

  Color get _foreground {
    switch (tone) {
      case AppStatusTone.success:
        return AppColors.onSuccessContainer;
      case AppStatusTone.warning:
        return AppColors.onWarningContainer;
      case AppStatusTone.error:
        return AppColors.onErrorContainer;
      case AppStatusTone.info:
        return AppColors.onInfoContainer;
      case AppStatusTone.primary:
        return AppColors.onPrimaryContainer;
      case AppStatusTone.neutral:
        return AppColors.textSecondary;
    }
  }

  Color get _background {
    switch (tone) {
      case AppStatusTone.success:
        return AppColors.successContainer;
      case AppStatusTone.warning:
        return AppColors.warningContainer;
      case AppStatusTone.error:
        return AppColors.errorContainer;
      case AppStatusTone.info:
        return AppColors.infoContainer;
      case AppStatusTone.primary:
        return AppColors.primaryContainer;
      case AppStatusTone.neutral:
        return AppColors.surfaceSoft;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 32),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: AppRadius.full,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: _foreground),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: _foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
