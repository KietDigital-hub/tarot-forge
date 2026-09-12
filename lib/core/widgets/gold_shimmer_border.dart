import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A shimmering gold aura and animated outline for mystical elements.
class GoldShimmerBorder extends StatefulWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final double borderWidth;
  final bool enablePulse;
  final Color? baseColor;
  final Color? accentColor;

  const GoldShimmerBorder({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.borderWidth = 1.5,
    this.enablePulse = true,
    this.baseColor,
    this.accentColor,
  });

  @override
  State<GoldShimmerBorder> createState() => _GoldShimmerBorderState();
}

class _GoldShimmerBorderState extends State<GoldShimmerBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    if (widget.enablePulse) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant GoldShimmerBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enablePulse != oldWidget.enablePulse) {
      if (widget.enablePulse) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = widget.baseColor ?? AppColors.goldPrimary;
    final bright = widget.accentColor ?? AppColors.goldBright;
    final dark = Color.lerp(primary, Colors.black, 0.45)!;

    if (!widget.enablePulse) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          border: Border.all(
            color: primary,
            width: widget.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.25),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: widget.child,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = _controller.value * 2 * 3.1415926;
        return Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            boxShadow: [
              BoxShadow(
                color: primary.withValues(
                  alpha: 0.20 + 0.15 * (1.0 + (child != null ? 0 : 0)),
                ),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
            gradient: SweepGradient(
              transform: GradientRotation(angle),
              colors: [
                primary,
                bright,
                dark,
                bright,
                primary,
              ],
            ),
          ),
          padding: EdgeInsets.all(widget.borderWidth),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              (widget.borderRadius.topLeft.x - widget.borderWidth).clamp(0, 999),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}
