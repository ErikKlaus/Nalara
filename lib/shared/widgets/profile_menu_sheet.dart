import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/colors/app_colors.dart';
import '../../core/localization/locale_controller.dart';
import '../../core/spacing/app_spacing.dart';
import '../../features/auth/domain/entities/auth_user.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';

class ProfileMenuSheet extends ConsumerWidget {
  final AuthUser user;

  const ProfileMenuSheet({super.key, required this.user});

  static Future<void> show(BuildContext context, AuthUser user) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ProfileMenuSheet(user: user),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final languageCode = ref.watch(localeControllerProvider).languageCode;
    final l10n = lookupAppLocalizations(Locale(languageCode));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _ProfileAvatar(user: user, radius: 28),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        user.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.languageLabel,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'id',
                  label: Text(l10n.languageOptionIndonesian),
                ),
                ButtonSegment(
                  value: 'en',
                  label: Text(l10n.languageOptionEnglish),
                ),
              ],
              selected: {languageCode},
              onSelectionChanged: (selection) async {
                final selected = selection.first;
                await ref
                    .read(localeControllerProvider.notifier)
                    .setLanguage(selected);
                if (!context.mounted) return;
                final newL10n = lookupAppLocalizations(Locale(selected));
                final languageLabel = selected == 'id'
                    ? newL10n.languageOptionIndonesian
                    : newL10n.languageOptionEnglish;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(newL10n.languageChangedMessage(languageLabel)),
                  ),
                );
              },
              showSelectedIcon: false,
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: authState.isLoading
                  ? null
                  : () async => _confirmLogout(context, ref),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.errorContainer),
              ),
              icon: authState.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.logout_rounded),
              label: Text(l10n.logout),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final languageCode = ref.read(localeControllerProvider).languageCode;
    final l10n = lookupAppLocalizations(Locale(languageCode));
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logoutTitle),
        content: Text(l10n.logoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    Navigator.of(context).pop();
    await ref.read(authControllerProvider.notifier).signOut();
  }
}

class _ProfileAvatar extends StatelessWidget {
  final AuthUser user;
  final double radius;

  const _ProfileAvatar({required this.user, required this.radius});

  @override
  Widget build(BuildContext context) {
    if (user.photoUrl != null && user.photoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(user.photoUrl!),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryContainer,
      child: Text(
        user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : 'N',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
