import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../loaders/insight_skeleton.dart';
import '../../providers/insights_provider.dart';
import '../../widgets/app_bar_tittle.dart';
import '../../widgets/back_button.dart';

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
        automaticallyImplyLeading: false,
        title: AppBarTitle(text: 'Insights'),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // if you need this
              side: BorderSide(
                color: Colors.grey.withOpacity(0.8),
                width: 1,
              ),
            ),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // if you need this
              side: BorderSide(
                color: Colors.grey.withOpacity(0.8),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Total Pinned Posts',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Earning from Posts:   ', // Use userInsight here instead of insightProvider.userInsight
                  ),
                  trailing:  Text(NumberFormat('#,###').format(userInsight['total_post']),style:  TextStyle(fontSize: 15)),
                ),
                // Add more content related to pinned posts here if needed
              ],
            ),
          ),
          SizedBox(height: 20), // Adjust spacing as needed
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // if you need this
              side: BorderSide(
                color: Colors.grey.withOpacity(0.8),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Total Subscriptions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Earnings from Subscriptions: ', // Use userInsight here instead of insightProvider.userInsight
                  ),
                    trailing:Text(
                       NumberFormat('#,###').format(userInsight['total_subscription']),style:  TextStyle(fontSize: 15) // Use userInsight here instead of insightProvider.userInsight
                    ),
                ),
                // Add more content related to subscriptions here if needed
              ],
            ),
          ),
          SizedBox(height: 20), // Adjust spacing as needed
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // if you need this
              side: BorderSide(
                color: Colors.grey.withOpacity(0.8),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Total Messages',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Earnings from Messages: ', // Use userInsight here instead of insightProvider.userInsight
                  ),
                  trailing: Text(NumberFormat('#,###').format(userInsight['total_messages']), style:  TextStyle(fontSize: 15)),
                ),
                // Add more content related to messages here if needed
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
