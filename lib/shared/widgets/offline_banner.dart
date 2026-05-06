import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/spacing/app_spacing.dart';

class OfflineBanner extends StatelessWidget {
  final String message;

  const OfflineBanner({
    super.key,
    this.message =
        'Kamu sedang offline. Perubahan akan disinkronkan saat online.',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      color: AppColors.warningContainer,
      child: Row(
        children: [
          const Icon(Icons.wifi_off, color: AppColors.warning),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
