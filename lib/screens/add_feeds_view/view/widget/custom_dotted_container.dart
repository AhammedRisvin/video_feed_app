import 'package:dotted_border/dotted_border.dart' as db;
import 'package:flutter/material.dart';

class CustomDottedContainer extends StatelessWidget {
  final Widget? child;
  final double borderRadius;
  final double dashLength;
  final Color dashColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final double strokeWidth;

  const CustomDottedContainer({
    super.key,
    this.child,
    this.borderRadius = 10,
    this.dashLength = 12,
    this.dashColor = Colors.white30,
    this.backgroundColor = const Color(0xFF1A1A1A),
    this.padding = const EdgeInsets.all(16),
    this.strokeWidth = 0.9,
  });

  @override
  Widget build(BuildContext context) {
    return db.DottedBorder(
      color: dashColor,
      strokeWidth: strokeWidth,
      dashPattern: [dashLength, dashLength],
      borderType: db.BorderType.RRect,
      radius: Radius.circular(borderRadius),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(borderRadius)),
        child: child,
      ),
    );
  }
}
