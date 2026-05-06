import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../../../core/radius/app_radius.dart';
import '../../../../core/spacing/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/layouts/responsive_page.dart';
import '../../../../shared/widgets/nalara_app_bar.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguage = ref.watch(localeControllerProvider).languageCode;
    final l10n = lookupAppLocalizations(Locale(selectedLanguage));

    return Scaffold(
      appBar: NalaraAppBar(title: l10n.languageLabel, showBackButton: true),
      body: SafeArea(
        child: ResponsivePage(
          maxWidth: 560,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.languageSelectionDescription,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              _LanguageCard(
                title: l10n.languageOptionIndonesian,
                subtitle: l10n.languageIndonesianSubtitle,
                icon: Icons.translate_rounded,
                selected: selectedLanguage == 'id',
                onTap: () => _selectLanguage(context, ref, 'id'),
              ),
              const SizedBox(height: AppSpacing.sm),
              _LanguageCard(
                title: l10n.languageOptionEnglish,
                subtitle: l10n.languageEnglishSubtitle,
                icon: Icons.language_rounded,
                selected: selectedLanguage == 'en',
                onTap: () => _selectLanguage(context, ref, 'en'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectLanguage(
    BuildContext context,
    WidgetRef ref,
    String languageCode,
  ) async {
    await ref.read(localeControllerProvider.notifier).setLanguage(languageCode);
    if (!context.mounted) return;

    final newL10n = lookupAppLocalizations(Locale(languageCode));
    final languageLabel = languageCode == 'id'
        ? newL10n.languageOptionIndonesian
        : newL10n.languageOptionEnglish;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(newL10n.languageChangedMessage(languageLabel)),
      ),
    );
    Navigator.of(context).pop(languageCode);
  }
}

class _LanguageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected ? AppColors.primaryContainer : AppColors.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.large,
        child: Padding(
          padding: AppSpacing.cardLarge,
          child: Row(
            children: [
              Icon(
                icon,
                color: selected
                    ? AppColors.onPrimaryContainer
                    : AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.micro),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
