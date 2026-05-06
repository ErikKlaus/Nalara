import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/radius/app_radius.dart';
import '../../../../core/spacing/app_spacing.dart';
import '../../../../core/tokens/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/layouts/responsive_page.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_status_chip.dart';
import '../../../../shared/widgets/nalara_app_bar.dart';
import '../../../../shared/widgets/reminder_banner.dart';
import '../../../analysis/domain/repositories/analysis_repository.dart';
import '../../../analysis/presentation/providers/analysis_provider.dart';
import 'history_screen.dart';
import 'input_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isWide =
        MediaQuery.sizeOf(context).width >= AppTokens.navigationRailBreakpoint;

    final pages = [
      _DashboardView(
        onStartAnalysis: _openInput,
        onOpenDrafts: () => setState(() => _selectedIndex = 2),
      ),
      const DecisionHistoryView(embedded: true),
      const DecisionHistoryView(embedded: true, initialStatusFilter: 'draft'),
    ];

    return Scaffold(
      appBar: NalaraAppBar(
        title: switch (_selectedIndex) {
          0 => 'Nalara',
          1 => l10n.decisionHistory,
          _ => l10n.draft,
        },
      ),
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.space_dashboard_outlined),
                  selectedIcon: const Icon(Icons.space_dashboard_rounded),
                  label: l10n.dashboard,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.history_outlined),
                  selectedIcon: const Icon(Icons.history_rounded),
                  label: l10n.decisionHistory,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.edit_note_outlined),
                  selectedIcon: const Icon(Icons.edit_note_rounded),
                  label: l10n.draft,
                ),
              ],
            ),
      body: SafeArea(
        child: Row(
          children: [
            if (isWide)
              NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() => _selectedIndex = index);
                },
                labelType: NavigationRailLabelType.all,
                destinations: [
                  NavigationRailDestination(
                    icon: const Icon(Icons.space_dashboard_outlined),
                    selectedIcon: const Icon(Icons.space_dashboard_rounded),
                    label: Text(l10n.dashboard),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.history_outlined),
                    selectedIcon: const Icon(Icons.history_rounded),
                    label: Text(l10n.decisionHistory),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.edit_note_outlined),
                    selectedIcon: const Icon(Icons.edit_note_rounded),
                    label: Text(l10n.draft),
                  ),
                ],
              ),
            Expanded(child: pages[_selectedIndex]),
          ],
        ),
      ),
    );
  }

  void _openInput({String? category}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, _) =>
            InputScreen(initialCategory: category),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.03),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class _DashboardView extends ConsumerWidget {
  final void Function({String? category}) onStartAnalysis;
  final VoidCallback onOpenDrafts;

  const _DashboardView({
    required this.onStartAnalysis,
    required this.onOpenDrafts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usage = ref.watch(usageLimitProvider);
    final l10n = AppLocalizations.of(context)!;

    return ResponsivePage(
      maxWidth: AppTokens.maxWideContentWidth,
      child: RefreshIndicator(
        onRefresh: () async {
          final refreshed = ref.refresh(usageLimitProvider.future);
          await refreshed;
        },
        child: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            _StrikePanel(l10n: l10n),
            const SizedBox(height: AppSpacing.sm),
            _HeroPanel(
              l10n: l10n,
              usage: usage,
              onStartAnalysis: () => onStartAnalysis(),
            ),
            const SizedBox(height: AppSpacing.md),
            ReminderBanner(
              title: l10n.reviewReminderTitle,
              message: l10n.reviewReminderMessage,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.decisionPromptTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            _QuickActionGrid(
              onCareer: () => onStartAnalysis(category: 'karir'),
              onFinancial: () => onStartAnalysis(category: 'finansial'),
              onDraft: onOpenDrafts,
              l10n: l10n,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  final AppLocalizations l10n;
  final AsyncValue<UsageLimit> usage;
  final VoidCallback onStartAnalysis;

  const _HeroPanel({
    required this.l10n,
    required this.usage,
    required this.onStartAnalysis,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: AppSpacing.cardLarge,
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppStatusChip(
            label: l10n.decisionIntelligence,
            tone: AppStatusTone.primary,
            icon: Icons.auto_awesome_rounded,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.homeHeroHeadline,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.homeHeroDescription,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          usage.when(
            data: (data) => _UsageBar(
              remaining: data.remaining,
              dailyLimit: data.dailyLimit,
              l10n: l10n,
            ),
            loading: () => const LinearProgressIndicator(minHeight: 8),
            error: (_, _) => AppStatusChip(
              label: l10n.limitUnavailableChip,
              tone: AppStatusTone.warning,
              icon: Icons.info_outline_rounded,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _AnalysisPrimaryButton(
            label: l10n.newAnalysis,
            onPressed: onStartAnalysis,
          ),
        ],
      ),
    );
  }
}

class _AnalysisPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _AnalysisPrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(64)),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
        backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
        foregroundColor: const WidgetStatePropertyAll(AppColors.surface),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: AppRadius.extraLarge),
        ),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.surface.withValues(alpha: 0.16);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.surface.withValues(alpha: 0.08);
          }
          return null;
        }),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.16),
              borderRadius: AppRadius.medium,
            ),
            child: const Icon(Icons.auto_awesome_rounded, size: 18),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.surface,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          const Icon(Icons.arrow_forward_rounded, size: 20),
        ],
      ),
    );
  }
}

class _UsageBar extends StatelessWidget {
  final int remaining;
  final int dailyLimit;
  final AppLocalizations l10n;

  const _UsageBar({
    required this.remaining,
    required this.dailyLimit,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final used = (dailyLimit - remaining).clamp(0, dailyLimit);
    final progress = dailyLimit == 0 ? 0.0 : used / dailyLimit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.remainingAnalysis(remaining),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Text(
              l10n.analysisUsed(used, dailyLimit),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: AppRadius.full,
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.surfaceSoft,
            color: remaining == 0 ? AppColors.error : AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _StrikePanel extends StatefulWidget {
  final AppLocalizations l10n;

  const _StrikePanel({required this.l10n});

  @override
  State<_StrikePanel> createState() => _StrikePanelState();
}

class _StrikePanelState extends State<_StrikePanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1 + (_controller.value * 0.8), -1),
              end: Alignment(1 - (_controller.value * 0.8), 1),
              colors: const [
                AppColors.primaryDark,
                AppColors.primary,
                AppColors.primaryLight,
              ],
            ),
            borderRadius: AppRadius.extraLarge,
            boxShadow: AppTokens.softShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: AppColors.surface,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                widget.l10n.streakDays(0),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.surface,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickActionGrid extends StatelessWidget {
  final VoidCallback onCareer;
  final VoidCallback onFinancial;
  final VoidCallback onDraft;
  final AppLocalizations l10n;

  const _QuickActionGrid({
    required this.onCareer,
    required this.onFinancial,
    required this.onDraft,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 720 ? 3 : 1;
        return GridView.count(
          crossAxisCount: columns,
          mainAxisSpacing: AppSpacing.sm,
          crossAxisSpacing: AppSpacing.sm,
          childAspectRatio: columns == 1 ? 4.2 : 1.35,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _QuickActionCard(
              title: l10n.career,
              message: l10n.careerShortcutMessage,
              icon: Icons.work_outline_rounded,
              onTap: onCareer,
            ),
            _QuickActionCard(
              title: l10n.financial,
              message: l10n.financialShortcutMessage,
              icon: Icons.account_balance_wallet_outlined,
              onTap: onFinancial,
            ),
            _QuickActionCard(
              title: l10n.draftShortcutTitle,
              message: l10n.draftShortcutMessage,
              icon: Icons.edit_note_rounded,
              onTap: onDraft,
            ),
          ],
        );
      },
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.message,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: AppRadius.large,
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.micro),
                Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
