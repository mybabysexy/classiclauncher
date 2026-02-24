import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CustomPageView extends StatefulWidget {
  final BoxConstraints constraints;
  final List<Widget> children;
  final ValueNotifier<int> pageNotifier;
  /// Notifier updated immediately when a target page is decided (before animation ends).
  final ValueNotifier<int>? targetPageNotifier;
  /// Called the moment a horizontal swipe gesture starts.
  final VoidCallback? onSwipeStart;

  const CustomPageView({
    super.key,
    required this.constraints,
    required this.children,
    required this.pageNotifier,
    this.targetPageNotifier,
    this.onSwipeStart,
  });

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Widget> _pages;

  /// Continuous scroll position in page units. 0.0 = page 0, 1.0 = page 1, etc.
  double _offset = 0.0;

  /// Page index at the start of a drag gesture.
  double _dragStartOffset = 0.0;

  // Velocity threshold (px/s) for a short fast swipe to trigger a page turn.
  static const double _velocityThreshold = 400.0;
  // Distance threshold (fraction of page width) for a slow drag to trigger a page turn.
  static const double _distanceThreshold = 0.22;

  int get _currentPage => _offset.round().clamp(0, _pages.length - 1);
  int get _pageCount => _pages.length;

  @override
  void initState() {
    super.initState();
    _offset = widget.pageNotifier.value.toDouble();
    _pages = widget.children.map((c) => RepaintBoundary(child: c)).toList();

    // Controller drives the spring settle animation; its value maps directly to _offset.
    _controller = AnimationController.unbounded(vsync: this);
    _controller.addListener(() {
      setState(() {
        _offset = _controller.value.clamp(0.0, (_pageCount - 1).toDouble());
      });
      // Sync pageNotifier once the spring has nearly settled.
      if (!_controller.isAnimating) {
        _syncPageNotifier();
      }
    });

    widget.pageNotifier.addListener(_onExternalPageChange);
  }

  void _onExternalPageChange() {
    final target = widget.pageNotifier.value.clamp(0, _pageCount - 1).toDouble();
    if (target == _offset) return;
    widget.targetPageNotifier?.value = target.toInt();
    _animateTo(target, velocityPxPerSec: 0);
  }

  /// Animate _offset to [target] page using a spring, with optional fling velocity.
  void _animateTo(double target, {required double velocityPxPerSec}) {
    final width = widget.constraints.maxWidth;
    // Convert px/s velocity to page-units/s
    final velocityInPageUnits = velocityPxPerSec / width;
    final spring = SpringDescription.withDampingRatio(mass: 1, stiffness: 800, ratio: 1.1);
    final simulation = SpringSimulation(spring, _offset, target, -velocityInPageUnits);
    _controller.animateWith(simulation);
  }

  void _settleToNearest({required double velocityPxPerSec, required double dragDelta}) {
    // dragDelta: positive = user dragged left (scrolled forward), negative = dragged right (scrolled back)
    // velocityPxPerSec: positive = moving left (forward page), negative = moving right (back page)
    final int startPage = _dragStartOffset.round();
    int targetPage = startPage; // default: snap back to where we started

    final bool wantsForward = velocityPxPerSec > _velocityThreshold ||
        (velocityPxPerSec >= -_velocityThreshold && dragDelta / widget.constraints.maxWidth > _distanceThreshold);
    final bool wantsBack = velocityPxPerSec < -_velocityThreshold ||
        (velocityPxPerSec <= _velocityThreshold && dragDelta / widget.constraints.maxWidth < -_distanceThreshold);

    if (wantsForward) {
      targetPage = startPage + 1;
    } else if (wantsBack) {
      targetPage = startPage - 1;
    }

    targetPage = targetPage.clamp(0, _pageCount - 1);
    widget.targetPageNotifier?.value = targetPage;
    // Only carry velocity into the spring for flings, to avoid overshooting past the target page.
    final springVelocity = (velocityPxPerSec.abs() > _velocityThreshold) ? velocityPxPerSec : 0.0;
    _animateTo(targetPage.toDouble(), velocityPxPerSec: springVelocity);
  }

  void _syncPageNotifier() {
    final page = _currentPage;
    if (widget.pageNotifier.value != page) {
      widget.pageNotifier.removeListener(_onExternalPageChange);
      widget.pageNotifier.value = page;
      widget.pageNotifier.addListener(_onExternalPageChange);
    }
  }

  @override
  void didUpdateWidget(CustomPageView old) {
    super.didUpdateWidget(old);
    if (widget.children != old.children) {
      _pages = widget.children.map((c) => RepaintBoundary(child: c)).toList();
      // Clamp offset if page count shrank.
      final maxOffset = (_pageCount - 1).toDouble();
      if (_offset > maxOffset) {
        _offset = maxOffset;
        _controller.value = _offset;
      }
    }
  }

  @override
  void dispose() {
    widget.pageNotifier.removeListener(_onExternalPageChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.constraints.maxWidth;
    final height = widget.constraints.maxHeight;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (details) {
        _controller.stop();
        _dragStartOffset = _offset;
        widget.onSwipeStart?.call();
      },
      onHorizontalDragUpdate: (details) {
        if (width == 0) return;
        final newOffset = (_offset - details.delta.dx / width)
            .clamp(0.0, (_pageCount - 1).toDouble());
        setState(() => _offset = newOffset);
      },
      onHorizontalDragEnd: (details) {
        // primaryVelocity: positive = finger moving right, negative = finger moving left.
        // We flip: positive velocity = scrolling forward (left swipe).
        final velocity = -(details.primaryVelocity ?? 0);
        // dragDelta in px: positive = user swiped left (scrolled forward).
        final dragDelta = (_offset - _dragStartOffset) * width;
        _settleToNearest(velocityPxPerSec: velocity, dragDelta: dragDelta);
      },
      child: SizedBox(
        width: width,
        height: height,
        child: ClipRect(
          child: Stack(
            children: _buildPages(width, height),
          ),
        ),
      ),
    );
  }

  /// Builds only the (at most 2) visible pages with the directional slide+fade effect:
  /// - The leaving page stays fully opaque and slides out.
  /// - The incoming page slides in from the edge and fades from 0→1.
  List<Widget> _buildPages(double width, double height) {
    final int basePage = _offset.floor().clamp(0, _pageCount - 1);
    final double frac = _offset - basePage; // 0.0 → 1.0

    final List<Widget> result = [];

    for (int i = 0; i < _pageCount; i++) {
      final double rawDist = i - _offset; // negative = left, positive = right
      final double absDist = rawDist.abs();

      // Skip pages completely off-screen.
      if (absDist >= 1.0) continue;

      if (i == basePage) {
        // ── Leaving page: stays fully opaque, slides out in the swipe direction.
        final double dx = -frac * width;
        result.add(_buildPageWidget(i, dx, 1.0, width, height));
      } else {
        // ── Incoming page: slides in ahead of the swipe, overlapping the leaving page.
        // dx = rawDist * width normally mirrors 1:1. We scale it down so the incoming page
        // is already well into the screen early on (overlapping page 1 from the right).
        // At frac=0.7 (absDist=0.3): dx = 0.3 * 0.5 * width = 0.15*width → 85% visible (heavy overlap).
        // Scale of 0.5 means the incoming page travels at half the distance → always ahead.
        final double dx = rawDist * width * 0.7;
        // Opacity grows as the page approaches center using an easeIn curve.
        final double opacityT = (1.0 - absDist).clamp(0.0, 1.0);
        final double opacity = Curves.easeIn.transform(opacityT);
        result.add(_buildPageWidget(i, dx, opacity, width, height));
      }
    }

    return result;
  }

  Widget _buildPageWidget(int index, double dx, double opacity, double width, double height) {
    return Transform.translate(
      offset: Offset(dx, 0),
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: SizedBox(width: width, height: height, child: _pages[index]),
      ),
    );
  }
}
