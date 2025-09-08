import 'package:flutter/material.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/models/onboarding_item.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {
  int currentIndex = 0; // Index of the current slide

  // List of onboarding items
  late final List<OnboardingItem> items = [
    OnboardingItem(
      image: AppAssets.onboarding2,
      title: AppLocalizations.of(context)!.onboarding2_title1,
      subtitle:
          AppLocalizations.of(context)!.onboarding2_subtitle1,
    ),
    OnboardingItem(
      image: AppAssets.onboarding3,
      title: AppLocalizations.of(context)!.onboarding2_title2,
      subtitle:
          AppLocalizations.of(context)!.onboarding2_subtitle2,
    ),
    OnboardingItem(
      image: AppAssets.onboarding4,
      title: AppLocalizations.of(context)!.onboarding2_title3,
      subtitle:
          AppLocalizations.of(context)!.onboarding2_subtitle3,
    ),
    OnboardingItem(
      image: AppAssets.onboarding5,
      title: AppLocalizations.of(context)!.onboarding2_title4,
      subtitle:
          AppLocalizations.of(context)!.onboarding2_subtitle4,
    ),
    OnboardingItem(
      image: AppAssets.onboarding6,
      title: AppLocalizations.of(context)!.onboarding2_title5,
      subtitle: null, 
    ),
  ];

  // This method is called when the introduction is completed
  // It saves a preference indicating that the user has seen the onboarding screen
  Future<void> _completeOnboarding(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('seenOnboarding', true);
  if (context.mounted) {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}

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

                    // Button
                    CustomButton(
                      textStyle: AppStyles.semibold20black,
                      onPressed: () {
                        setState(() {
                          if (currentIndex == items.length - 1) {
                            _completeOnboarding(context);
                          } else if (currentIndex < items.length - 1) {
                            currentIndex++;
                          }
                        });
                      },
                      text: (currentIndex == items.length - 1)
                          ? AppLocalizations.of(context)!.finish
                          : AppLocalizations.of(context)!.next,
                    ),
                    SizedBox(height: height * 0.02),

                    // Back button
                    if (currentIndex >= 1) ...[ // ... is used to unpack the list
                      CustomButton(
                        text: AppLocalizations.of(context)!.back,
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
