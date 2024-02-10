import 'package:flutter/material.dart';

class PercentageLoadingIndicator extends StatelessWidget {
  final double progress;

  const PercentageLoadingIndicator({
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress,
      minHeight: 10,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }
}
