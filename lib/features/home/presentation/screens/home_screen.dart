import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/core/theme/app_spacing.dart';
import 'package:app_template/core/theme/app_theme.dart';
import 'package:app_template/core/widgets/pull_to_refresh_haptic.dart';
import 'package:app_template/features/shell/presentation/providers/scroll_to_top_provider.dart';
import 'package:app_template/l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const _branchIndex = 0;
  final _scrollController = ScrollController();

  static const _items = <_DemoItem>[
    _DemoItem(icon: Icons.bolt, title: 'Riverpod', subtitle: 'State management'),
    _DemoItem(icon: Icons.alt_route, title: 'GoRouter', subtitle: 'Declarative routing'),
    _DemoItem(icon: Icons.cloud, title: 'Dio + Retrofit', subtitle: 'Typed HTTP client'),
    _DemoItem(icon: Icons.lock_outline, title: 'Secure storage', subtitle: 'Token persistence'),
    _DemoItem(icon: Icons.translate, title: 'L10n', subtitle: 'Multi-language ready'),
    _DemoItem(icon: Icons.palette_outlined, title: 'Theme tokens', subtitle: 'Light + dark'),
    _DemoItem(icon: Icons.bug_report_outlined, title: 'Sentry', subtitle: 'Error reporting'),
    _DemoItem(icon: Icons.analytics_outlined, title: 'PostHog', subtitle: 'Analytics'),
  ];

  @override
  void initState() {
    super.initState();
    ref.listenManual(scrollToTopSignalProvider, (prev, next) {
      if (next.branch == _branchIndex && prev?.counter != next.counter) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabHome),
      ),
      body: PullToRefreshHaptic(
        onRefresh: _onRefresh,
        child: ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: _items.length + 1,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Text(
                  l10n.homeIntro,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              );
            }
            final item = _items[index - 1];
            return Card(
              child: ListTile(
                leading: Icon(item.icon, color: theme.colorScheme.primary),
                title: Text(item.title),
                subtitle: Text(item.subtitle),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DemoItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const _DemoItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
