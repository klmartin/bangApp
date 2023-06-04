import 'package:flutter/material.dart';
import 'package:nallagram/screens/Story/storyview.dart';
import 'package:nallagram/widgets/blog_element.dart';


class BlogShrink {
  BlogShrink({
    @required this.tName,
    @required this.tColor,
    @required this.title,
    @required this.text,
    @required this.author,
    @required this.image,
    @required this.comments,
    @required this.time,
  });
  final String title;
  final String tName;
  final Color tColor;
  final String text;
  final String time;
  final String author;
  final String image;
  final int comments;
}
class StoryWid extends StatelessWidget {
  final String name;
  final String img;

  const StoryWid({Key key, this.name ,this.img}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <BlogElement>[
          BlogElement(
        title:"" ,
          comments:2 ,
          author:"" ,
          time: "",
          text: "",
          image: "",
          tagName:"",
          tagColor: Color.fromARGB(1, 30, 34, 45),
        )
        ]),
      );
  }
}
