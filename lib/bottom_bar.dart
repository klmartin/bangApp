import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.grey.shade200,
      buttonBackgroundColor: Colors.redAccent.shade100,
      height: 50.0,
      color: Colors.white,
      items: <Widget>[
        Icon(
          Icons.home,
          color: Colors.black,
          size: 25,
        ),
        Icon(
          Icons.search,
          color: Colors.black,
          size: 25.0,
        ),
        Icon(
          Icons.create_outlined,
          color: Colors.black,
          size: 25.0,
        ),
        FaIcon(
          FontAwesomeIcons.heart,
          size: 25.0,
        ),
        Icon(
          Icons.person_outline,
          color: Colors.black,
          size: 25.0,
        ),
      ],
      index: widget.currentIndex,
    onTap: _onItemTap,
    );
  }
}
