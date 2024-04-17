import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../loaders/insight_skeleton.dart';
import '../../providers/insights_provider.dart';

class Insight extends StatefulWidget {
  @override
  _InsightState createState() => _InsightState();
}

class _InsightState extends State<Insight> {
  late InsightProvider insightProvider;

  @override
  void initState() {
    super.initState();
    insightProvider = Provider.of<InsightProvider>(context, listen: false);
    insightProvider.fetchInsight();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insights'),
      ),
      body: Consumer<InsightProvider>(
        builder: (context, insightProvider, _) {
          return insightProvider.loading
              ? InsightSkeleton()
              : insightProvider.userInsight.isEmpty
                  ? Center(child: Text('No data available'))
                  : InsightCards(userInsight: insightProvider.userInsight);
        },
      ),
    );
  }
}

class InsightCards extends StatelessWidget {
  final Map<String, dynamic> userInsight;

  const InsightCards({required this.userInsight});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    NumberFormat('#,###').format(userInsight['total_earned']),
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25), // Adjust spacing as needed
          Card(

            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Total Pinned Posts',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Earning from Posts:   ${NumberFormat('#,###').format(userInsight['total_post'])}', // Use userInsight here instead of insightProvider.userInsight
                  ),
                ),
                // Add more content related to pinned posts here if needed
              ],
            ),
          ),
          SizedBox(height: 20), // Adjust spacing as needed
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Total Subscriptions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Earnings from Subscriptions: ${NumberFormat('#,###').format(userInsight['total_subscription'])}', // Use userInsight here instead of insightProvider.userInsight
                  ),
                ),
                // Add more content related to subscriptions here if needed
              ],
            ),
          ),
          SizedBox(height: 20), // Adjust spacing as needed
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Total Messages',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Earnings from Messages: ${NumberFormat('#,###').format(userInsight['total_messages'])} ', // Use userInsight here instead of insightProvider.userInsight
                  ),
                ),
                // Add more content related to messages here if needed
              ],
            ),
          ),
          SizedBox(height: 20),
          Table(
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Percentage',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Recipient',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          '25%',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Bangapp',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          '75%',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'You',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
