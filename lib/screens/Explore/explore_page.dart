import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/widgets/SearchBox.dart';
import 'package:bangapp/widgets/buildBangUpdate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}



class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBox(),
        SizedBox(height: 10),
        Expanded(
          child: BangUpdates(),
        ),
      ],
    );
  }
}

class BangUpdates extends StatelessWidget {
  Future<List<dynamic>> getBangUpdates() async {
    var response = await http.get(Uri.parse('https://kimjotech.com/BangAppBackend/api/bang-updates'));
    var data = json.decode(response.body);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getBangUpdates(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlue,
            ),
          );
        }
        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            final post = snapshot.data[index];
            final filename = post['filename'];
            final type = post['type'];
            final caption = post['caption'];
            return Container(
              height: MediaQuery.of(context).size.height,
              child: AspectRatio(
                aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
                child: buildBangUpdate(context, filename, type, caption),
              ),
            );
          },
          controller: PageController(),
        );
      },
    );
  }
}





