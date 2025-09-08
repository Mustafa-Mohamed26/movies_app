import 'package:flutter/material.dart';

class CustomScreenShot extends StatelessWidget {
  String image;
  CustomScreenShot({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
      ),
    );
  }
}
