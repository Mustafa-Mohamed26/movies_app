import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_styles.dart';

class CustomCard extends StatelessWidget {
  final String image;
  final double rate;
  const CustomCard({super.key, required this.image, required this.rate});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Container(
      width: width * 0.55,
      height: height * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // ظل أخف
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // الصورة
            Positioned.fill(
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),

            // Gradient خفيف عشان يوضح النصوص بس
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.4), // بدل 0.7 خليتها أفتح
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // التقييم
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.003,
                  horizontal: width * 0.02,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("$rate", style: AppStyles.regular16white),
                    Text(" ⭐", style: AppStyles.regular16white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
