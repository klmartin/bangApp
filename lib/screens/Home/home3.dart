import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';

class Home3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

if (homeProvider.posts == null || homeProvider.posts!.isEmpty) {
      homeProvider.fetchData();
    }
    
    return Scaffold(
      body: homeProvider.loading
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
            )
          : homeProvider.error
              ? Center(
                  child: homeProvider.errorDialog(size: 20),
                )
              : homeProvider.posts == null || homeProvider.posts!.isEmpty
                  ? Center(
                      child: Text("No posts available."),
                    )
                  : buildPostsView(context),
    );
  }

  Widget buildPostsView(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return ListView.builder(
      itemCount: homeProvider.posts!.length + (homeProvider.isLastPage ? 0 : 1) + (homeProvider.posts!.isEmpty ? 0 : 1),
      itemBuilder: (context, index) {
        return Container(
          child: Column(
            children: [
              Text("hello"),
              Text("Hello2")
            ],
          ),
        );
      },
    );
  }
}
