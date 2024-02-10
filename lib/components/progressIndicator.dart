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
      backgroundColor: Color.fromARGB(255, 239, 90, 4),
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }
}
