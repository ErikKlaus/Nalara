import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/colors/app_colors.dart';
import '../../core/spacing/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'profile_menu_sheet.dart';

class NalaraAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget> actions;

  const NalaraAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.actions = const [],
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;

    return AppBar(
      automaticallyImplyLeading: showBackButton,
      titleSpacing: showBackButton ? 0 : AppSpacing.sm,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.titleLarge.copyWith(
          color: AppColors.primary,
          fontFamily: 'Batangas',
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        ...actions,
        if (user != null)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Tooltip(
              message: 'Profil',
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => ProfileMenuSheet.show(context, user),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primaryContainer,
                  backgroundImage:
                      user.photoUrl != null && user.photoUrl!.isNotEmpty
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null || user.photoUrl!.isEmpty
                      ? Text(
                          user.displayName.isNotEmpty
                              ? user.displayName[0].toUpperCase()
                              : 'N',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: AppColors.onPrimaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                        )
                      : null,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
