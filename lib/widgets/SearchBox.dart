import 'package:flutter/material.dart';
import 'package:bangapp/screens/Profile/profilelist_page.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileList()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        height: 40.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Chemba ya Umbea".toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 4,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(width: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
