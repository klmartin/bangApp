import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Category1 extends StatelessWidget {
  Category1({required this.catName});

  String catName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 12, right: 12),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 48, 48, 48),
            borderRadius: BorderRadius.circular(25)),
        child: Center(
          child: Text(
            catName,
            style: TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 222, 221, 221)),
          ),
        ),
      ),
    );
  }
}
