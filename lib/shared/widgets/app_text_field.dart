import 'package:flutter/material.dart';

import '../../core/spacing/app_spacing.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const AppTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.maxLines = 1,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(hintText: hintText, errorText: errorText),
        ),
      ],
    );
  }
}
