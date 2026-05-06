import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/radius/app_radius.dart';
import '../../../../core/spacing/app_spacing.dart';
import '../../../../shared/helpers/date_helper.dart';
import '../../../../shared/widgets/app_status_chip.dart';
import '../../domain/entities/decision.dart';

class DecisionCard extends StatelessWidget {
  final Decision decision;
  final VoidCallback? onTap;

  const DecisionCard({super.key, required this.decision, this.onTap});

  AppStatusTone _statusTone() {
    switch (decision.status) {
      case 'draft':
        return AppStatusTone.neutral;
      case 'dianalisis':
        return AppStatusTone.info;
      case 'selesai':
        return AppStatusTone.success;
      case 'dihapus':
        return AppStatusTone.error;
      default:
        return AppStatusTone.neutral;
    }
  }

  String _statusLabel() {
    switch (decision.status) {
      case 'draft':
        return 'Draft';
      case 'dianalisis':
        return 'Dianalisis';
      case 'selesai':
        return 'Selesai';
      case 'dihapus':
        return 'Dihapus';
      default:
        return decision.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.large,
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
                      decision.inputText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppStatusChip(label: _statusLabel(), tone: _statusTone()),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(
                    decision.category == 'finansial'
                        ? Icons.account_balance_wallet_outlined
                        : Icons.work_outline_rounded,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    decision.category,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    DateHelper.timeAgo(decision.createdAt),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
