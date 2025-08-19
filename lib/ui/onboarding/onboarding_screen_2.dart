import 'package:flutter/material.dart';
import 'package:movies_app/model/onboarding_item.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/widgets/custom_button.dart';

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {
  int currentIndex = 0;

  final List<OnboardingItem> items = [
    OnboardingItem(
      image: AppAssets.onboarding2,
      title: "Discover Movies",
      subtitle:
          "Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.",
    ),
    OnboardingItem(
      image: AppAssets.onboarding3,
      title: "Explore All Genres",
      subtitle:
          "Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.",
    ),
    OnboardingItem(
      image: AppAssets.onboarding4,
      title: "Create Watch lists",
      subtitle:
          "Save movies to your watch list to keep track of what you want to watch next. Enjoy films in various qualities and genres.",
    ),
    OnboardingItem(
      image: AppAssets.onboarding5,
      title: "Rate, Review, and Learn",
      subtitle:
          "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",
    ),
    OnboardingItem(
      image: AppAssets.onboarding6,
      title: "Start Watching Now",
      subtitle: null, // آخر واحدة بدون subtitle
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final item = items[currentIndex];

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(child: Image.asset(item.image, fit: BoxFit.cover)),

          // Foreground content
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: width * 0.03,
                  right: width * 0.03,
                  top: height * 0.03,
                ),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      item.title,
                      style: AppStyles.bold24white,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: height * 0.02),

                    // Only show subtitle if not null
                    if (item.subtitle != null) ...[
                      // spread operator is used to unpack the list
                      Text(
                        item.subtitle!,
                        style: AppStyles.regular20white,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: height * 0.02),
                    ],

                    CustomButton(
                      textStyle: AppStyles.semibold20black,
                      onPressed: () {
                        setState(() {
                          if (currentIndex == items.length - 1) {
                            // navigate to home screen
                          } else if (currentIndex < items.length - 1) {
                            currentIndex++;
                          }
                        });
                      },
                      text: (currentIndex == items.length - 1)
                          ? "Finish"
                          : "Next",
                    ),
                    SizedBox(height: height * 0.02),

                    if (currentIndex >= 1) ...[
                      CustomButton(
                        text: "Back",
                        backgroundColor: AppColors.black,
                        mainAxisAlignment: MainAxisAlignment.center,
                        textStyle: AppStyles.regular20yellow,
                        onPressed: () {
                          setState(() {
                            if (currentIndex > 0) {
                              currentIndex--;
                            }
                          });
                        },
                      ),
                      SizedBox(height: height * 0.02),
                    ],

                    SizedBox(height: height * 0.03),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
