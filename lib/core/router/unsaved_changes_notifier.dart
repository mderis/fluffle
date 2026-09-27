import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks whether the current screen has unsaved changes.
/// The shell checks this before allowing navigation away.
final unsavedChangesNotifierProvider = NotifierProvider<UnsavedChangesNotifier, bool>(
  UnsavedChangesNotifier.new,
);

class UnsavedChangesNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setDirty() => state = true;
  void clear() => state = false;
}
