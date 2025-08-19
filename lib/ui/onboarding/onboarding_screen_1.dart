import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/widgets/custom_button.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(AppAssets.onboarding1, fit: BoxFit.cover),
          ),

          // Foreground content
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Find Your Next Favorite Movie Here",
                  style: AppStyles.medium36white,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height * 0.02),
                Text(
                  "Get access to a huge library of movies to suit all tastes. You will surely like it.",
                  style: AppStyles.regular20white,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height * 0.02),
                CustomButton(onPressed: (){}, text: "Explore Now"),
                SizedBox(height: height * 0.03),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
