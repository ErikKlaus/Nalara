import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/radius/app_radius.dart';
import '../../core/spacing/app_spacing.dart';
import '../../core/tokens/app_tokens.dart';
import '../../l10n/app_localizations.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style:
          ElevatedButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            minimumSize: const Size.fromHeight(AppTokens.minTouchTarget + 8),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.extraLarge,
              side: const BorderSide(color: AppColors.border),
            ),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return AppColors.primary.withValues(alpha: 0.08);
              }
              if (states.contains(WidgetState.hovered)) {
                return AppColors.primary.withValues(alpha: 0.04);
              }
              return null;
            }),
          ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Logo-Google.png',
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  AppLocalizations.of(context)?.continueWithGoogle ??
                      'Lanjut dengan Google',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }
}
