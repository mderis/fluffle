import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wraps a scrollable [child] with a [RefreshIndicator] that also emits
/// incremental haptic "ticks" as the user pulls, plus a firmer impact at
/// the trigger threshold.
///
/// The sensation mimics a physical ratchet — feedback every [tickEvery]
/// pixels of overscroll, culminating in a single medium impact when the
/// refresh is about to fire.
class PullToRefreshHaptic extends StatefulWidget {
  const PullToRefreshHaptic({
    super.key,
    required this.onRefresh,
    required this.child,
    this.tickEvery = 14,
    this.triggerAt = 80,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  /// Distance (in pixels of overscroll) between haptic ticks while pulling.
  final double tickEvery;

  /// Pull distance at which a firmer impact fires, signaling "release now
  /// and it'll refresh".
  final double triggerAt;

  @override
  State<PullToRefreshHaptic> createState() => _PullToRefreshHapticState();
}

class _PullToRefreshHapticState extends State<PullToRefreshHaptic> {
  double _ticksFired = 0;
  bool _triggerArmed = false;

  bool _handleNotification(ScrollNotification n) {
    final metrics = n.metrics;
    if (metrics.axis != Axis.vertical) return false;

    // `pixels < minScrollExtent` means the user pulled past the top edge.
    final overscroll = metrics.minScrollExtent - metrics.pixels;

    if (n is ScrollStartNotification || n is ScrollEndNotification) {
      _ticksFired = 0;
      _triggerArmed = false;
      return false;
    }

    if (overscroll <= 0) {
      _ticksFired = 0;
      _triggerArmed = false;
      return false;
    }

    final ticksDue = overscroll ~/ widget.tickEvery;
    if (ticksDue > _ticksFired) {
      _ticksFired = ticksDue.toDouble();
      HapticFeedback.selectionClick();
    }

    if (!_triggerArmed && overscroll >= widget.triggerAt) {
      _triggerArmed = true;
      HapticFeedback.mediumImpact();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleNotification,
      child: RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: widget.child,
      ),
    );
  }
}
