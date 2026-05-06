import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/radius/app_radius.dart';
import '../../../../core/spacing/app_spacing.dart';
import '../../../../shared/layouts/responsive_page.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/nalara_app_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/decision_provider.dart';
import '../widgets/decision_card.dart';
import 'detail_screen.dart';

class HistoryScreen extends ConsumerWidget {
  final String? initialStatusFilter;

  const HistoryScreen({super.key, this.initialStatusFilter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: NalaraAppBar(title: l10n.decisionHistory, showBackButton: true),
      body: SafeArea(
        child: DecisionHistoryView(initialStatusFilter: initialStatusFilter),
      ),
    );
  }
}

class DecisionHistoryView extends ConsumerStatefulWidget {
  final bool embedded;
  final String? initialStatusFilter;

  const DecisionHistoryView({
    super.key,
    this.embedded = false,
    this.initialStatusFilter,
  });

  @override
  ConsumerState<DecisionHistoryView> createState() =>
      _DecisionHistoryViewState();
}

class _DecisionHistoryViewState extends ConsumerState<DecisionHistoryView> {
  late String? _statusFilter;

  @override
  void initState() {
    super.initState();
    _statusFilter = widget.initialStatusFilter;
  }

  @override
  Widget build(BuildContext context) {
    final decisions = ref.watch(decisionsStreamProvider);
    final l10n = AppLocalizations.of(context)!;

    return decisions.when(
      data: (items) {
        final filteredItems = _statusFilter == null
            ? items
            : items.where((item) => item.status == _statusFilter).toList();
        final hasItems = items.isNotEmpty;
        final children = <Widget>[];

        if (hasItems) {
          children
            ..add(
              _HistoryFilterBar(
                selectedStatus: _statusFilter,
                onChanged: (value) => setState(() => _statusFilter = value),
              ),
            )
            ..add(const SizedBox(height: AppSpacing.sm));
        }

        if (!hasItems) {
          children.add(
            EmptyStateWidget(
              icon: Icons.history_rounded,
              title: l10n.emptyHistoryTitle,
              message: l10n.emptyHistoryMessage,
              actionLabel: widget.embedded ? null : l10n.newAnalysis,
              onAction: widget.embedded
                  ? null
                  : () => Navigator.of(context).pop(),
            ),
          );
        } else if (filteredItems.isEmpty) {
          children.add(
            EmptyStateWidget(
              icon: Icons.edit_note_rounded,
              title: _statusFilter == 'draft'
                  ? l10n.emptyDraftTitle
                  : l10n.emptyFilteredTitle,
              message: _statusFilter == 'draft'
                  ? l10n.emptyDraftMessage
                  : l10n.emptyFilteredMessage,
            ),
          );
        } else {
          for (var index = 0; index < filteredItems.length; index++) {
            children.add(
              DecisionCard(
                decision: filteredItems[index],
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, animation, _) =>
                          DetailScreen(decision: filteredItems[index]),
                      transitionsBuilder: (_, animation, _, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
              ),
            );
            if (index != filteredItems.length - 1) {
              children.add(const SizedBox(height: AppSpacing.sm));
            }
          }
        }

        return ResponsivePage(
          padding: EdgeInsets.zero,
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(decisionsStreamProvider);
              await Future<void>.delayed(const Duration(milliseconds: 350));
            },
            child: ListView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.all(AppSpacing.md),
              children: children,
            ),
          ),
        );
      },
      loading: () =>
          Center(child: LoadingIndicator(message: l10n.historyLoading)),
      error: (error, _) => AppErrorWidget(message: error.toString()),
    );
  }
}

class _HistoryFilterBar extends StatelessWidget {
  final String? selectedStatus;
  final ValueChanged<String?> onChanged;

  const _HistoryFilterBar({
    required this.selectedStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: l10n.filterAll,
            selected: selectedStatus == null,
            onTap: () => onChanged(null),
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            label: l10n.filterDraft,
            selected: selectedStatus == 'draft',
            onTap: () => onChanged('draft'),
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            label: l10n.filterAnalyzed,
            selected: selectedStatus == 'dianalisis',
            onTap: () => onChanged('dianalisis'),
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            label: l10n.filterDone,
            selected: selectedStatus == 'selesai',
            onTap: () => onChanged('selesai'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryContainer : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.full,
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.border,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.full,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: selected
                  ? AppColors.onPrimaryContainer
                  : AppColors.textSecondary,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
