import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/radius/app_radius.dart';
import '../../../../core/spacing/app_spacing.dart';
import '../../../../shared/layouts/responsive_page.dart';
import '../../../../l10n/app_localizations.dart';

class AnalysisLoadingScreen extends StatelessWidget {
  final String? message;

  const AnalysisLoadingScreen({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final displayMessage = message ?? l10n.analysisLoadingMessage;

    return Scaffold(
      body: SafeArea(
        child: ResponsivePage(
          maxWidth: 760,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: AppRadius.extraLarge,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                displayMessage,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.analysisLoadingDescription,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: AppColors.border,
                  highlightColor: AppColors.surface,
                  child: ListView.separated(
                    itemCount: 5,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      return Container(
                        height: index == 0 ? 156 : 112,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppRadius.large,
                          border: Border.all(color: AppColors.border),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
