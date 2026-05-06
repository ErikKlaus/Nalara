import 'package:flutter/material.dart';

import '../../core/spacing/app_spacing.dart';
import '../../core/tokens/app_tokens.dart';

class ResponsivePage extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final Alignment alignment;

  const ResponsivePage({
    super.key,
    required this.child,
    this.maxWidth = AppTokens.maxContentWidth,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final resolvedPadding =
        padding ?? (width < 600 ? AppSpacing.screenCompact : AppSpacing.screen);

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: resolvedPadding, child: child),
      ),
    );
  }
}
