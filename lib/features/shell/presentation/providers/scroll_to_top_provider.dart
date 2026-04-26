import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One-shot event emitted when the user re-taps an already-active bottom tab.
/// Screens for each branch listen and, when [branch] matches theirs AND
/// [counter] has advanced, scroll their list to the top.
class ScrollToTopEvent {
  final int branch;
  final int counter;

  const ScrollToTopEvent(this.branch, this.counter);

  /// Sentinel used while no tap has happened yet.
  static const none = ScrollToTopEvent(-1, 0);
}

final scrollToTopSignalProvider =
    NotifierProvider<ScrollToTopSignal, ScrollToTopEvent>(
        ScrollToTopSignal.new);

class ScrollToTopSignal extends Notifier<ScrollToTopEvent> {
  @override
  ScrollToTopEvent build() => ScrollToTopEvent.none;

  void bump(int branch) =>
      state = ScrollToTopEvent(branch, state.counter + 1);
}
