import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:movies_app/models/movie_data.dart';
import 'package:movies_app/ui/home/tabs/profile/bloc/profile_view_model.dart';
import 'package:movies_app/ui/auth/login_screen.dart';
import 'package:movies_app/ui/auth/register_screen.dart';
import 'package:movies_app/ui/auth/forgot_password_screen.dart';
import 'package:movies_app/ui/home/tabs/profile/profile_reset_password_screen.dart';
import 'package:movies_app/ui/onboarding/onboarding_screen_1.dart';
import 'package:movies_app/ui/onboarding/onboarding_screen_2.dart';
import 'package:movies_app/ui/home/home_screen.dart';
import 'package:movies_app/ui/home/tabs/profile/update_profile_screen.dart';
import 'package:movies_app/ui/details/details_screen.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_theme.dart';
import 'package:path_provider/path_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(MovieDataAdapter());
  runApp(
    BlocProvider<ProfileViewModel>(
      create: (_) => ProfileViewModel()
        ..getProfile()
        ..getAllFavorites()
        ..loadHistory(),
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
        AppRoutes.resetPassword: (context) => ProfileResetPasswordScreen(),
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
