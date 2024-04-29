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
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () async {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFF40BF5),
                      Color(0xFFBF46BE),
                      Color(0xFFF40BF5)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(Icons.arrow_back_rounded, size: 30),
              ),
              SizedBox(width: 8), // Add some space between the icon and the text
              Text('Insights'),
            ],
          ),
        ),
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
