import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A widget that applies an interactive 3D perspective tilt and dynamic
/// specular sheen to simulate holding and angling a physical Tarot card.
class TiltCardContainer extends StatefulWidget {
  final Widget child;
  final double maxTiltAngle;
  final double perspective;
  final BorderRadius borderRadius;

  const TiltCardContainer({
    super.key,
    required this.child,
    this.maxTiltAngle = 0.20, // radians (~11.5 degrees)
    this.perspective = 0.0018,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  State<TiltCardContainer> createState() => _TiltCardContainerState();
}

class _TiltCardContainerState extends State<TiltCardContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _resetController;
  late Animation<Offset> _resetAnimation;

  Offset _tiltOffset = Offset.zero; // normalized between -1.0 and 1.0

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..addListener(() {
        setState(() {
          _tiltOffset = _resetAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    _resetController.stop();
    setState(() {
      final dx = (details.localPosition.dx / size.width) * 2 - 1;
      final dy = (details.localPosition.dy / size.height) * 2 - 1;
      _tiltOffset = Offset(
        dx.clamp(-1.0, 1.0),
        dy.clamp(-1.0, 1.0),
      );
    });
  }

  void _onHoverUpdate(PointerEvent details, Size size) {
    _resetController.stop();
    setState(() {
      final dx = (details.localPosition.dx / size.width) * 2 - 1;
      final dy = (details.localPosition.dy / size.height) * 2 - 1;
      _tiltOffset = Offset(
        dx.clamp(-1.0, 1.0),
        dy.clamp(-1.0, 1.0),
      );
    });
  }

  void _resetTilt() {
    _resetAnimation = Tween<Offset>(
      begin: _tiltOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _resetController,
        curve: Curves.easeOutBack,
      ),
    );
    _resetController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        // Calculate rotation angles
        final rotX = -_tiltOffset.dy * widget.maxTiltAngle;
        final rotY = _tiltOffset.dx * widget.maxTiltAngle;

        final transform = Matrix4.identity()
          ..setEntry(3, 2, widget.perspective)
          ..rotateX(rotX)
          ..rotateY(rotY);

        return MouseRegion(
          onHover: (e) => _onHoverUpdate(e, size),
          onExit: (_) => _resetTilt(),
          child: GestureDetector(
            onPanUpdate: (details) => _onPanUpdate(details, size),
            onPanEnd: (_) => _resetTilt(),
            onPanCancel: _resetTilt,
            child: Transform(
              transform: transform,
              alignment: FractionalOffset.center,
              child: Stack(
                children: [
                  widget.child,
                  // Dynamic specular sheen overlay
                  if (_tiltOffset != Offset.zero)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: ClipRRect(
                          borderRadius: widget.borderRadius,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment(
                                  -_tiltOffset.dx * 1.5,
                                  -_tiltOffset.dy * 1.5,
                                ),
                                radius: 1.2,
                                colors: [
                                  Colors.white.withValues(
                                    alpha: (math.sqrt(
                                              _tiltOffset.dx * _tiltOffset.dx +
                                                  _tiltOffset.dy * _tiltOffset.dy,
                                            ) *
                                            0.18)
                                        .clamp(0.0, 0.22),
                                  ),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
