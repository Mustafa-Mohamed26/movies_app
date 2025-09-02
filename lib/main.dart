import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/ui/home/tabs/profile/bloc/profile_view_model.dart';
import 'package:movies_app/ui/auth/login_screen.dart';
import 'package:movies_app/ui/auth/register_screen.dart';
import 'package:movies_app/ui/auth/forgot_password_screen.dart';
import 'package:movies_app/ui/onboarding/onboarding_screen_1.dart';
import 'package:movies_app/ui/onboarding/onboarding_screen_2.dart';
import 'package:movies_app/ui/home/home_screen.dart';
import 'package:movies_app/ui/home/tabs/profile/update_profile_screen.dart';
import 'package:movies_app/ui/details/details_screen.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    BlocProvider<ProfileViewModel>(
      create: (_) => ProfileViewModel()..getProfile(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => LoginScreen(),
        AppRoutes.register: (context) => RegisterScreen(),
        AppRoutes.forgotPassword: (context) => ForgotPasswordScreen(),
        AppRoutes.onboarding1: (context) => OnboardingScreen1(),
        AppRoutes.onboarding2: (context) => OnboardingScreen2(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.updateProfile: (context) => const UpdateProfileScreen(),
        AppRoutes.details: (context) {
          final movieId = ModalRoute.of(context)!.settings.arguments as int;
          return DetailsScreen(movieId: movieId);
        },
      },
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
    );
  }
}
