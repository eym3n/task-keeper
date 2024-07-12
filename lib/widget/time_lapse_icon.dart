import 'dart:math';

import 'package:flutter/material.dart';

class TimeLapseIcon extends StatefulWidget {
  final DateTime start;
  final DateTime end;
  const TimeLapseIcon({super.key, required this.start, required this.end});

  @override
  State<TimeLapseIcon> createState() => _TimeLapseIconState();
}

class _TimeLapseIconState extends State<TimeLapseIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.end.toLocal().difference(DateTime.now()),
      vsync: this,
    );

    var prg = (widget.end.difference(widget.start.toLocal()).inSeconds -
            DateTime.now().difference(widget.start.toLocal()).inSeconds) /
        widget.end.difference(widget.start.toLocal()).inSeconds;

    _animation = Tween<double>(begin: prg, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CustomPaint(
        painter: TimelapsePainter(_animation.value),
        size: const Size(10, 10),
      ),
    );
  }
}

class TimelapsePainter extends CustomPainter {
  final double progress;

  TimelapsePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    Paint borderPaint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double angle = 2 * pi * progress;

    // print(progress);

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -pi / 2,
      angle,
      false,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width + 4,
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
