import 'package:bangapp/widgets/SearchBox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bangapp/screens/blog/video_detail_screen.dart';
import 'package:bangapp/screens/blog/home_video.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BlogHome extends StatefulWidget {
  @override
  _BlogHomeState createState() => _BlogHomeState();
}

class _BlogHomeState extends State<BlogHome> {

  Future<List<dynamic>> getInspirations() async {
    var response = await http.get(Uri.parse('https://kimjotech.com/BangAppBackend/api/get/bangInspirations'));
    var data = json.decode(response.body);
    print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: SearchBox(),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height, // Set a height constraint
        child: FutureBuilder(
          future: getInspirations(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {

              return ListView.builder(
                itemCount:  snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VideoDetailScreen(
                                  title: snapshot.data[index]['tittle'],
                                  viewCount: snapshot.data[index]['view_count'],
                                  thumbnail: snapshot.data[index]['thumbnail'],
                                  dayAgo: snapshot.data[index]['created_at'],
                                  videoUrl: snapshot.data[index]['video_url'],
                                ),
                              ),
                            );
                          },
                          child: Image(
                            image: NetworkImage(snapshot.data[index]['thumbnail']),
                            centerSlice: Rect.largest,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data[index]['profile_url']),
                        ),
                        title: Text(
                          snapshot.data[index]['tittle'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          snapshot.data[index]['creator'] + " . " + snapshot.data[index]['created_at'],
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Icon(Icons.more_vert),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

