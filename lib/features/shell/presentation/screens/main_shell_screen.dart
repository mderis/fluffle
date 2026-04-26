import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:app_template/core/router/unsaved_changes_provider.dart';
import 'package:app_template/core/widgets/app_confirm_dialog.dart';
import 'package:app_template/features/shell/presentation/providers/scroll_to_top_provider.dart';
import 'package:app_template/features/shell/presentation/widgets/main_bottom_nav_bar.dart';
import 'package:app_template/l10n/app_localizations.dart';

class MainShellScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onTabSelected(context, ref, index),
      ),
    );
  }

  Future<void> _onTabSelected(
    BuildContext context,
    WidgetRef ref,
    int index,
  ) async {
    HapticFeedback.selectionClick();

    // Re-tapping the already-active tab → scroll that branch to top.
    if (index == navigationShell.currentIndex) {
      ref.read(scrollToTopSignalProvider.notifier).bump(index);
      return;
    }

    if (!await _guardUnsavedChanges(context, ref)) return;

    navigationShell.goBranch(index);
  }

  Future<bool> _guardUnsavedChanges(BuildContext context, WidgetRef ref) async {
    if (!ref.read(unsavedChangesProvider)) return true;

    final l10n = L10n.of(context);
    final discard = await AppConfirmDialog.show(
      context: context,
      icon: Icons.warning_amber_rounded,
      title: l10n.discardChanges,
      body: l10n.discardChangesBody,
      confirmLabel: l10n.discard,
      cancelLabel: l10n.keepEditing,
      haptic: true,
    );

    if (!discard || !context.mounted) return false;
    ref.read(unsavedChangesProvider.notifier).clear();
    return true;
  }
}
