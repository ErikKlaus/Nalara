import 'package:flutter/material.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/spacing/app_spacing.dart';
import '../../../../shared/helpers/date_helper.dart';
import '../../../../shared/layouts/responsive_page.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_status_chip.dart';
import '../../../../shared/widgets/nalara_app_bar.dart';
import '../../domain/entities/decision.dart';

class DetailScreen extends StatelessWidget {
  final Decision decision;

  const DetailScreen({super.key, required this.decision});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NalaraAppBar(
        title: 'Detail Keputusan',
        showBackButton: true,
      ),
      body: SafeArea(
        child: ResponsivePage(
          maxWidth: 760,
          child: ListView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              AppCard(
                padding: AppSpacing.cardLarge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Keputusan',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        AppStatusChip(
                          label: decision.status,
                          tone: decision.status == 'selesai'
                              ? AppStatusTone.success
                              : AppStatusTone.info,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      decision.inputText,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        AppStatusChip(
                          label: decision.category,
                          tone: AppStatusTone.primary,
                          icon: decision.category == 'finansial'
                              ? Icons.account_balance_wallet_outlined
                              : Icons.work_outline_rounded,
                        ),
                        AppStatusChip(
                          label: DateHelper.formatDate(decision.createdAt),
                          tone: AppStatusTone.neutral,
                          icon: Icons.calendar_today_outlined,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (decision.notes != null && decision.notes!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  padding: AppSpacing.cardLarge,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Catatan Follow-up',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        decision.notes!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.sticky_note_2_outlined,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Belum ada catatan follow-up untuk keputusan ini.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
