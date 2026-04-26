import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:app_template/core/router/app_routes.dart';
import 'package:app_template/core/theme/app_spacing.dart';
import 'package:app_template/features/auth/presentation/providers/auth_notifier.dart';
import 'package:app_template/l10n/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final user = ref.watch(authNotifierProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabProfile),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.go(AppRoutes.editProfile),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    (user?.displayName.isNotEmpty ?? false)
                        ? user!.displayName[0].toUpperCase()
                        : '?',
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  user?.displayName ?? l10n.profile,
                  style: theme.textTheme.titleLarge,
                ),
                if (user?.email != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(user!.email, style: theme.textTheme.bodyMedium),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: Text(l10n.settings),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go(AppRoutes.settings),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: Text(
                    l10n.logout,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () => ref.read(authNotifierProvider.notifier).logout(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
