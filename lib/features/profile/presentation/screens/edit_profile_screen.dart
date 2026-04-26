import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/core/theme/app_spacing.dart';
import 'package:app_template/l10n/app_localizations.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfile)),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Text('Edit Profile screen — placeholder'),
        ),
      ),
    );
  }
}
