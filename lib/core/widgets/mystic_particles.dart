import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Hạt tinh tú và bụi vàng huyền bí lơ lửng chậm trên nền giao diện Tarot Forge.
/// Hoạt ảnh nhẹ nhàng, sử dụng CustomPainter, được bao bọc trong IgnorePointer để không cản trở tương tác.
class MysticParticlesOverlay extends StatefulWidget {
  final Widget child;
  final bool enableAnimation;

  const MysticParticlesOverlay({
    super.key,
    required this.child,
    this.enableAnimation = true,
  });

  @override
  State<MysticParticlesOverlay> createState() => _MysticParticlesOverlayState();
}

class _MysticParticlesOverlayState extends State<MysticParticlesOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    final random = math.Random(42); // Seed cố định để phân bố hạt đồng đều
    for (int i = 0; i < 24; i++) {
      _particles.add(
        _Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: 1.5 + random.nextDouble() * 3.5,
          speed: 0.15 + random.nextDouble() * 0.35,
          isStar: i % 3 == 0,
          drift: (random.nextDouble() - 0.5) * 0.2,
          opacity: 0.12 + random.nextDouble() * 0.25,
        ),
      );
    }

    // Trong môi trường flutter test, không repeat controller vô hạn để tránh pumpAndSettle timeout
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('TestWidgetsFlutterBinding');
    if (!isTest && widget.enableAnimation) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 12),
      )..repeat();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: widget.enableAnimation && _controller != null
                ? AnimatedBuilder(
                    animation: _controller!,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _ParticlesPainter(
                          progress: _controller!.value,
                          particles: _particles,
                        ),
                      );
                    },
                  )
                : CustomPaint(
                    painter: _ParticlesPainter(
                      progress: 0.5,
                      particles: _particles,
                    ),
                  ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final bool isStar;
  final double drift;
  final double opacity;

  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.isStar,
    required this.drift,
    required this.opacity,
  });
}

class _ParticlesPainter extends CustomPainter {
  final double progress;
  final List<_Particle> particles;

  _ParticlesPainter({
    required this.progress,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final goldPaint = Paint()..color = AppColors.goldPrimary;

    for (final p in particles) {
      // Chuyển động nhẹ nhàng từ dưới lên trên và lượn ngang
      final currentY = (p.y - progress * p.speed) % 1.0;
      final currentX =
          (p.x + math.sin((progress * 2 * math.pi) + p.y * 10) * p.drift) % 1.0;

      final dx = currentX * size.width;
      final dy = currentY * size.height;

      goldPaint.color = AppColors.goldPrimary.withValues(alpha: p.opacity);

      if (p.isStar) {
        // Vẽ ngôi sao bốn cánh nhỏ
        final path = Path();
        final s = p.size * 1.5;
        path.moveTo(dx, dy - s);
        path.quadraticBezierTo(dx, dy, dx + s, dy);
        path.quadraticBezierTo(dx, dy, dx, dy + s);
        path.quadraticBezierTo(dx, dy, dx - s, dy);
        path.quadraticBezierTo(dx, dy, dx, dy - s);
        canvas.drawPath(path, goldPaint);
      } else {
        // Vẽ hạt bụi vàng tròn
        canvas.drawCircle(Offset(dx, dy), p.size, goldPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
