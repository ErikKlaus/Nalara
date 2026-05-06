import 'package:flutter/material.dart';

import '../../core/radius/app_radius.dart';
import '../../core/spacing/app_spacing.dart';
import '../../core/tokens/app_tokens.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final Color? color;

  const AppCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.card,
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.large,
        child: AnimatedContainer(
          duration: AppTokens.quickMotion,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
