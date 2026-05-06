import 'package:flutter/material.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/radius/app_radius.dart';
import '../../../../core/spacing/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/layouts/responsive_page.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_status_chip.dart';
import '../../../../shared/widgets/nalara_app_bar.dart';
import '../../domain/entities/analysis_entity.dart';
import '../../domain/entities/scenario_entity.dart';
import '../../domain/repositories/analysis_repository.dart';

class AnalysisResultScreen extends StatelessWidget {
  final AnalysisEntity analysis;
  final UsageLimit? usage;

  const AnalysisResultScreen({super.key, required this.analysis, this.usage});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLowConfidence = analysis.overallConfidence == 'rendah';

    return Scaffold(
      appBar: NalaraAppBar(
        title: l10n.analysisResultTitle,
        showBackButton: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(l10n.analysisFixInput),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.analysisSavedSnackbar)),
                    );
                  },
                  icon: const Icon(Icons.bookmark_add_outlined),
                  label: Text(l10n.analysisSaveResult),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ResponsivePage(
          maxWidth: 820,
          child: ListView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              _ResultHeader(analysis: analysis, usage: usage),
              if (isLowConfidence) ...[
                const SizedBox(height: AppSpacing.sm),
                _ConfidenceWarning(reason: analysis.confidenceReason),
              ],
              const SizedBox(height: AppSpacing.md),
              _ScenarioSection(scenarios: analysis.scenarios),
              const SizedBox(height: AppSpacing.sm),
              _CauseSection(scenarios: analysis.scenarios),
              const SizedBox(height: AppSpacing.sm),
              _IndicatorSection(scenarios: analysis.scenarios),
              const SizedBox(height: AppSpacing.sm),
              _PreventionSection(scenarios: analysis.scenarios),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultHeader extends StatelessWidget {
  final AnalysisEntity analysis;
  final UsageLimit? usage;

  const _ResultHeader({required this.analysis, required this.usage});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      padding: AppSpacing.cardLarge,
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.analysisCompleteTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.analysisCompleteDescription,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _ConfidenceMeter(confidence: analysis.overallConfidence),
            ],
          ),
          if (usage != null) ...[
            const SizedBox(height: AppSpacing.md),
            AppStatusChip(
              label: l10n.analysisRemainingChip(
                usage!.remaining,
                usage!.dailyLimit,
              ),
              tone: usage!.remaining == 0
                  ? AppStatusTone.warning
                  : AppStatusTone.info,
              icon: Icons.bolt_outlined,
            ),
          ],
        ],
      ),
    );
  }
}

class _ConfidenceMeter extends StatelessWidget {
  final String confidence;

  const _ConfidenceMeter({required this.confidence});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final value = switch (confidence) {
      'tinggi' => 1.0,
      'sedang' => 0.66,
      'rendah' => 0.34,
      _ => 0.5,
    };
    final color = switch (confidence) {
      'tinggi' => AppColors.success,
      'sedang' => AppColors.warning,
      'rendah' => AppColors.error,
      _ => AppColors.info,
    };

    return SizedBox(
      width: 100,
      child: Column(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 8,
              backgroundColor: AppColors.surfaceSoft,
              color: color,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _confidenceLabel(confidence, l10n),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _ConfidenceWarning extends StatelessWidget {
  final String? reason;

  const _ConfidenceWarning({this.reason});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: AppSpacing.card,
      decoration: const BoxDecoration(
        color: AppColors.warningContainer,
        borderRadius: AppRadius.large,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.warning),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              reason?.isNotEmpty == true ? reason! : l10n.analysisLowConfidence,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onWarningContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScenarioSection extends StatelessWidget {
  final List<ScenarioEntity> scenarios;

  const _ScenarioSection({required this.scenarios});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _SectionCard(
      title: l10n.analysisScenarioTitle,
      icon: Icons.route_outlined,
      child: Column(
        children: [
          for (var i = 0; i < scenarios.length; i++) ...[
            _ScenarioTile(index: i + 1, scenario: scenarios[i]),
            if (i != scenarios.length - 1) const Divider(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _ScenarioTile extends StatelessWidget {
  final int index;
  final ScenarioEntity scenario;

  const _ScenarioTile({required this.index, required this.scenario});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      initiallyExpanded: index == 1,
      shape: const RoundedRectangleBorder(),
      title: Text(
        '$index. ${scenario.title}',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.micro),
        child: Text(
          scenario.narrative,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: AppStatusChip(
        label: _likelihoodLabel(scenario.likelihood, l10n),
        tone: _likelihoodTone(scenario.likelihood),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(
            scenario.narrative,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _CauseSection extends StatelessWidget {
  final List<ScenarioEntity> scenarios;

  const _CauseSection({required this.scenarios});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _SectionCard(
      title: l10n.analysisRootCauseLabel,
      icon: Icons.manage_search_rounded,
      child: Column(
        children: [
          for (final scenario in scenarios)
            _NumberedLine(
              label: scenario.id.toUpperCase(),
              text: scenario.mainCause,
            ),
        ],
      ),
    );
  }
}

class _IndicatorSection extends StatelessWidget {
  final List<ScenarioEntity> scenarios;

  const _IndicatorSection({required this.scenarios});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _SectionCard(
      title: l10n.earlyIndicatorsTitle,
      icon: Icons.radar_outlined,
      child: Column(
        children: [
          for (final scenario in scenarios)
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(bottom: AppSpacing.sm),
              title: Text(
                scenario.title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              children: [
                for (var i = 0; i < scenario.earlyIndicators.length; i++)
                  _NumberedLine(
                    label: '${i + 1}',
                    text: scenario.earlyIndicators[i],
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _PreventionSection extends StatelessWidget {
  final List<ScenarioEntity> scenarios;

  const _PreventionSection({required this.scenarios});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final actions = [
      for (final scenario in scenarios)
        for (final action in scenario.preventionActions)
          (title: scenario.title, action: action),
    ];

    return _SectionCard(
      title: l10n.preventiveActionsTitle,
      icon: Icons.task_alt_rounded,
      prominent: true,
      child: Column(
        children: [
          for (final item in actions)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: AppSpacing.card,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.large,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppStatusChip(
                    label: item.action.timing,
                    tone: AppStatusTone.primary,
                    icon: Icons.schedule_rounded,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    item.action.action,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.micro),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final bool prominent;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.prominent = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: AppSpacing.cardLarge,
      color: prominent ? AppColors.primaryContainer : AppColors.surfaceElevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _NumberedLine extends StatelessWidget {
  final String label;
  final String text;

  const _NumberedLine({required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: AppRadius.medium,
            ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

AppStatusTone _likelihoodTone(String likelihood) {
  switch (likelihood) {
    case 'tinggi':
      return AppStatusTone.error;
    case 'sedang':
      return AppStatusTone.warning;
    case 'rendah':
      return AppStatusTone.success;
    default:
      return AppStatusTone.info;
  }
}

String _likelihoodLabel(String likelihood, AppLocalizations l10n) {
  switch (likelihood) {
    case 'tinggi':
      return l10n.likelihoodHigh;
    case 'sedang':
      return l10n.likelihoodMedium;
    case 'rendah':
      return l10n.likelihoodLow;
    default:
      return likelihood;
  }
}

String _confidenceLabel(String confidence, AppLocalizations l10n) {
  switch (confidence) {
    case 'tinggi':
      return l10n.confidenceHigh;
    case 'sedang':
      return l10n.confidenceMedium;
    case 'rendah':
      return l10n.confidenceLow;
    default:
      return confidence;
  }
}
