import 'package:colorful_iconify_flutter/icons/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/language_cubit.dart';
import 'package:movies_app/widgets/custom_button.dart';
import 'package:movies_app/widgets/custom_switch.dart';

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({super.key});

  @override
  State<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  bool isEnglish = true;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var languageCubit = context.read<LanguageCubit>();
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
                  AppLocalizations.of(context)!.onboarding1_line1,
                  style: AppStyles.medium36white,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height * 0.02),
                Text(
                  AppLocalizations.of(context)!.onboarding1_line2,
                  style: AppStyles.regular20white,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height * 0.02),
                // CustomSwitch for language selection
                CustomSwitch(
                  value: isEnglish,
                  onToggle: (val) {
                    if (val) {
                      isEnglish = true;
                      setState(() {
                        languageCubit.changeLanguage(Locale("en"));
                      });
                    } else {
                      isEnglish = false;
                      setState(() {
                        languageCubit.changeLanguage(Locale("ar"));
                      });
                    }
                  },
                  activeIcon: Iconify(CircleFlags.lr),
                  inactiveIcon: Iconify(CircleFlags.eg),
                ),
                SizedBox(height: height * 0.02),
                // CustomButton for navigation
                CustomButton(
                  textStyle: AppStyles.semibold20black,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.onboarding2,
                      (arguments) => false,
                    );
                  },
                  text: AppLocalizations.of(context)!.onboarging1_explore,
                ),
                SizedBox(height: height * 0.03),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
