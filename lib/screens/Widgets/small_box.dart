import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SmallBoxCarousel extends StatelessWidget {
  final List<BoxData> boxes;

  SmallBoxCarousel({ this.boxes});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '     Bang Battle',
          style: TextStyle(fontFamily: 'Metropolis',
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              letterSpacing: -1),

        ),
        SizedBox(height: 10),
        CarouselSlider(
          options: CarouselOptions(
            height: 250,
            viewportFraction: 1.0,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 7),
          ),
          items: boxes.map((box) {
            if(box.imageUrl2 != null){
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      children: [
                        Row(  // Replace Column with Row
                          children: [
                            Expanded(
                              child: Container(
                                height: 200,
                                child: Image.network(
                                  box.imageUrl1,  // Replace with the URL of the first image
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),  // Add some spacing between the images
                            Expanded(
                              child: Container(
                                height: 200,
                                child: Image.network(
                                  box.imageUrl2,  // Replace with the URL of the second image
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          box.text,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              );

            }
            else{
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          child: Image.network(
                            box.imageUrl1,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          box.text,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

          }).toList(),
        ),
      ],
    );
  }


}

class BoxData {
  final String imageUrl1;
  final String imageUrl2;
  final String text;

  BoxData({ this.imageUrl1, this.imageUrl2,  this.text});
}
