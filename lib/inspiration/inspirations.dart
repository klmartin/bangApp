import 'package:bangapp/custom_appbar.dart';
import 'package:bangapp/inspiration/updates_page.dart';
import 'package:flutter/material.dart';

class BangInspiration extends StatelessWidget {
  const BangInspiration();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Bang Inspiration', context: context,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BangInspirationBuilder(),
          ],
        ),
      ),
    );
  }
}
