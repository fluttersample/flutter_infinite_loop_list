import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

/// A highly customizable infinite auto-scrolling list that supports
/// both horizontal and vertical orientations, configurable speed,
/// and pauses/resumes on user interaction.
///
/// The list automatically scrolls at a constant speed and seamlessly
/// loops back to the beginning when it reaches the end.
///
/// ### Features:
/// - Infinite looping
/// - Horizontal or vertical scrolling
/// - Configurable scroll speed (pixels per frame)
/// - Pauses when user interacts (drag), resumes after delay
/// - Uses `itemBuilder` for full customization
/// - Input validation via `assert`
///
/// ### Example Usage:
/// ```dart
/// InfiniteLoopList(
///   itemCount: 5,
///   itemBuilder: (context, index) => Text('Item $index'),
///   scrollDirection: Axis.vertical,
///   scrollSpeed: 2.0,
///   pauseDuration: Duration(seconds: 2),
/// )
/// ```
class InfiniteLoopList extends StatefulWidget {
  /// The number of items in the repeating list.
  final int itemCount;

  /// Optional custom scroll behavior for the list.
  final MaterialScrollBehavior? scrollBehavior;

  /// Builder function to create each item.
  /// The `index` is the logical index in the original list (0 to itemCount-1).
  final IndexedWidgetBuilder itemBuilder;

  /// Scroll direction: vertical or horizontal.
  final Axis scrollDirection;

  /// Speed of auto-scroll in pixels per frame (~60 FPS).
  /// Must be greater than 0.
  final double scrollSpeed;

  /// Duration to wait before resuming auto-scroll after user interaction.
  /// Defaults to 2 seconds.
  final Duration pauseDuration;

  /// Optional physics for manual scrolling.
  final ScrollPhysics? physics;

  /// Padding around the list.
  final EdgeInsetsGeometry? padding;

   InfiniteLoopList({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.scrollBehavior,
    this.scrollDirection = Axis.vertical,
    this.scrollSpeed = 1.0,
    this.pauseDuration = const Duration(seconds: 2),
    this.physics,
    this.padding,
  }) {
    assert(scrollSpeed > 0, 'scrollSpeed must be greater than 0');
    assert(pauseDuration > Duration.zero, 'pauseDuration must be positive');
  }

  @override
  State<InfiniteLoopList> createState() => _InfiniteLoopListState();
}

class _InfiniteLoopListState extends State<InfiniteLoopList> {
  late final ScrollController _controller;
  Timer? _autoScrollTimer;
  Timer? _resumeTimer;

// Large multiplier to ensure we can scroll far enough before looping
//   static const int _loopMultiplier = 1000;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!_controller.hasClients) return;

      final maxScroll = _controller.position.maxScrollExtent;
      final currentOffset = _controller.offset;
      final newOffset = currentOffset + _getSpeedPerFrame();

      if (newOffset >= maxScroll) {
// Jump to equivalent position in the first loop
        final loopedOffset = newOffset - maxScroll;
        _controller.jumpTo(loopedOffset);
      } else {
        _controller.jumpTo(newOffset);
      }
    });
  }

  double _getSpeedPerFrame() {
// Adjust speed based on direction and device pixel ratio
    final speed = widget.scrollSpeed;
    return speed;
  }

  void _pauseAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  void _scheduleResume() {
    _resumeTimer?.cancel();
    _resumeTimer = Timer(widget.pauseDuration, () {
      if (mounted) {
        _startAutoScroll();
      }
    });
  }

  @override
  void didUpdateWidget(covariant InfiniteLoopList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollSpeed != widget.scrollSpeed ||
        oldWidget.scrollDirection != widget.scrollDirection) {
      _startAutoScroll(); // Restart with new speed/direction
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _resumeTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: widget.scrollBehavior ?? MyCustomScrollBehavior(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
      // User started dragging
          if (notification is ScrollStartNotification &&
              notification.dragDetails != null) {
            _pauseAutoScroll();
            _resumeTimer?.cancel();
          }

      // User stopped dragging
          if (notification is ScrollEndNotification) {
            _scheduleResume();
          }

          return false;
        },
        child: ListView.builder(
          controller: _controller,
          // itemCount: widget.itemCount,
          scrollDirection: widget.scrollDirection,
          physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
          padding: widget.padding,
          itemBuilder: (context, index) {
            int originalIndex = index % widget.itemCount;
            return widget.itemBuilder(context, originalIndex);
          },
        ),
      ),
    );
  }
}
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

