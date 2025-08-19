import 'package:flutter/material.dart';
import 'package:movies_app/ui/auth/forgot_password_screen.dart';
import 'package:movies_app/ui/auth/login_screen.dart';
import 'package:movies_app/ui/auth/register_screen.dart';
import 'package:movies_app/ui/home/home_screen.dart';
import 'package:movies_app/ui/home/profile_screen.dart';
import 'package:movies_app/ui/onboarding/onboarding_screen_1.dart';
import 'package:movies_app/ui/onboarding/onboarding_screen_2.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
   Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) =>  LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
        AppRoutes.onboarding1: (context) => const OnboardingScreen1(),
        AppRoutes.onboarding2: (context) =>  OnboardingScreen2(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
      },

      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
    );
  }
}
