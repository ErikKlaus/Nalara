import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/radius/app_radius.dart';
import '../../../../core/spacing/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/tokens/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/layouts/responsive_page.dart';
import '../../../../shared/widgets/google_sign_in_button.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: AppColors.error,
            ),
          );
        },
      );
    });

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.surfaceTint,
              AppColors.background,
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: ResponsivePage(
            maxWidth: 420,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: AppTokens.standardMotion,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * AppSpacing.sm),
                    child: child,
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  Center(
                    child: Container(
                      width: 104,
                      height: 104,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.extraLarge,
                        boxShadow: AppTokens.softShadow,
                      ),
                      child: Image.asset('assets/images/Logo-1.png'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.appName,
                    textAlign: TextAlign.center,
                    style: AppTypography.displaySmall.copyWith(
                      color: AppColors.primary,
                      fontFamily: 'Batangas',
                    ),
                  ),
                  const Spacer(flex: 3),
                  GoogleSignInButton(
                    isLoading: authState.isLoading,
                    onPressed: () {
                      ref
                          .read(authControllerProvider.notifier)
                          .signInWithGoogle();
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
