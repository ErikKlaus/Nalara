import 'package:flutter/material.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/radius/app_radius.dart';
import '../../../../core/spacing/app_spacing.dart';

class CategorySelector extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;
  final String careerLabel;
  final String careerDescription;
  final String financeLabel;
  final String financeDescription;

  const CategorySelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.careerLabel = 'Karier',
    this.careerDescription = 'Kerja, studi, jabatan',
    this.financeLabel = 'Finansial',
    this.financeDescription = 'KPR, cicilan, budget',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CategoryOption(
            label: careerLabel,
            description: careerDescription,
            icon: Icons.work_outline_rounded,
            selected: value == 'karir',
            onTap: () => onChanged('karir'),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _CategoryOption(
            label: financeLabel,
            description: financeDescription,
            icon: Icons.account_balance_wallet_outlined,
            selected: value == 'finansial',
            onTap: () => onChanged('finansial'),
          ),
        ),
      ],
    );
  }
}

class _CategoryOption extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryOption({
    required this.label,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryContainer : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.large,
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.border,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.large,
        child: Padding(
          padding: AppSpacing.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: selected
                    ? AppColors.onPrimaryContainer
                    : AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(label, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSpacing.micro),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
