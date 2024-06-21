import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  final List<String> imgList;

  ImageCarousel({required this.imgList});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items: imgList.map((item) => Container(
        child: Center(
          child: Image.asset(item, fit: BoxFit.cover, width: 1000),
        ),
      )).toList(),
    );
  }
}
