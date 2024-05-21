import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class InsightSkeleton extends StatefulWidget {
  const InsightSkeleton();

  @override
  State<InsightSkeleton> createState() =>
      _InsightSkeletonState();
}

class _InsightSkeletonState extends State<InsightSkeleton> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: _enabled, child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Total Cash',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '\$500', // Replace this with your actual total cash amount
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16), // Adjust spacing as needed
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Total Pinned Posts',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Earned from Posts: \$100', // Replace with actual earnings
                  ),
                ),
                // Add more content related to pinned posts here if needed
              ],
            ),
          ),
          SizedBox(height: 16), // Adjust spacing as needed
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Total Pinned Posts',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Earned from Posts: \$100', // Replace with actual earnings
                  ),
                ),
                // Add more content related to pinned posts here if needed
              ],
            ),
          ),
          SizedBox(height: 16), // Adjust spacing as needed
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Total Pinned Posts',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Earned from Posts: \$100', // Replace with actual earnings
                  ),
                ),
                // Add more content related to pinned posts here if needed
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}
