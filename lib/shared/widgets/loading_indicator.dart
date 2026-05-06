import 'package:flutter/material.dart';

import '../../core/spacing/app_spacing.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        if (message != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(message!, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ],
    );
  }
}
