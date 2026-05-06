import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/radius/app_radius.dart';
import '../../../../core/spacing/app_spacing.dart';
import '../../../../shared/layouts/responsive_page.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_status_chip.dart';
import '../../../../shared/widgets/nalara_app_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/helpers/validation_helper.dart';
import '../../../analysis/presentation/providers/analysis_provider.dart'
    as analysis;
import '../../../analysis/presentation/screens/loading_screen.dart';
import '../../../analysis/presentation/screens/result_screen.dart';
import '../widgets/category_selector.dart';

class InputScreen extends ConsumerStatefulWidget {
  final String? initialCategory;

  const InputScreen({super.key, this.initialCategory});

  @override
  ConsumerState<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends ConsumerState<InputScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  String? _category;

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _inputFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final analysisState = ref.watch(analysis.analysisControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    if (analysisState is analysis.AnalysisLoading) {
      return AnalysisLoadingScreen(message: l10n.analysisLoadingMessage);
    }

    if (analysisState is analysis.AnalysisSuccess) {
      return AnalysisResultScreen(
        analysis: analysisState.analysis,
        usage: analysisState.usage,
      );
    }

    if (analysisState is analysis.AnalysisLowConfidence) {
      return AnalysisResultScreen(
        analysis: analysisState.analysis,
        usage: analysisState.usage,
      );
    }

    final wordCount = ValidationHelper.countWords(_controller.text);
    final hasValidText = ValidationHelper.isValidInput(_controller.text);
    final isValid = hasValidText && _category != null;
    final charsLeft = 500 - _controller.text.length;

    String? inlineMessage;
    AppStatusTone inlineTone = AppStatusTone.info;
    IconData inlineIcon = Icons.info_outline_rounded;
    if (analysisState is analysis.AnalysisClarificationNeeded) {
      inlineMessage = analysisState.question;
      inlineTone = AppStatusTone.warning;
      inlineIcon = Icons.psychology_alt_outlined;
    } else if (analysisState is analysis.AnalysisLimitReached) {
      inlineMessage = l10n.analysisLimitReached;
      inlineTone = AppStatusTone.warning;
      inlineIcon = Icons.hourglass_empty_rounded;
    } else if (analysisState is analysis.AnalysisError) {
      inlineMessage = analysisState.message;
      inlineTone = AppStatusTone.error;
      inlineIcon = Icons.error_outline_rounded;
    }

    return Scaffold(
      appBar: NalaraAppBar(title: l10n.analysisTitle, showBackButton: true),
      body: SafeArea(
        child: ResponsivePage(
          maxWidth: 720,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: [
                    Text(
                      l10n.analysisIntro,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (inlineMessage != null) ...[
                      _InlineAnalysisMessage(
                        message: inlineMessage,
                        tone: inlineTone,
                        icon: inlineIcon,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    AppCard(
                      padding: AppSpacing.cardLarge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l10n.decisionContextTitle,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                              AppStatusChip(
                                label: l10n.wordCountLabel(wordCount),
                                tone: wordCount >= 10
                                    ? AppStatusTone.success
                                    : AppStatusTone.neutral,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TextField(
                            controller: _controller,
                            focusNode: _inputFocusNode,
                            maxLines: 7,
                            maxLength: 500,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: l10n.decisionContextHint,
                              counterText: '',
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  hasValidText
                                      ? l10n.analysisContextEnough
                                      : l10n.analysisContextMinimum,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              Text(
                                l10n.charactersLeft(charsLeft),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.categoryLabel,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    CategorySelector(
                      value: _category,
                      onChanged: (value) => setState(() => _category = value),
                      careerLabel: l10n.career,
                      careerDescription: l10n.careerShortcutMessage,
                      financeLabel: l10n.financial,
                      financeDescription: l10n.financialShortcutMessage,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isValid ? _submit : null,
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: Text(l10n.analyzeAction),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    final languageCode = Localizations.localeOf(context).languageCode;
    ref
        .read(analysis.analysisControllerProvider.notifier)
        .analyzeDecision(
          inputText: _controller.text,
          category: _category!,
          language: languageCode,
        );
  }
}

class _InlineAnalysisMessage extends StatelessWidget {
  final String message;
  final AppStatusTone tone;
  final IconData icon;

  const _InlineAnalysisMessage({
    required this.message,
    required this.tone,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = switch (tone) {
      AppStatusTone.error => (
        background: AppColors.errorContainer,
        foreground: AppColors.onErrorContainer,
      ),
      AppStatusTone.warning => (
        background: AppColors.warningContainer,
        foreground: AppColors.onWarningContainer,
      ),
      _ => (
        background: AppColors.infoContainer,
        foreground: AppColors.onInfoContainer,
      ),
    };

    return Container(
      width: double.infinity,
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: AppRadius.large,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.foreground),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colors.foreground),
            ),
          ),
        ],
      ),
    );
  }
}
