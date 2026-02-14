import 'package:flutter/material.dart';

/// Reusable widget that displays an emoji (mood) icon with configurable font size.
class HumorIcon extends StatelessWidget {
  const HumorIcon({
    super.key,
    required this.text,
    this.fontSize = 36,
  });

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: fontSize));
  }
}
