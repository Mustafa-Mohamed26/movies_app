import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:movies_app/l10n/app_localizations.dart';
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
import 'package:movies_app/utils/language_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize Flutter widgets
  final appDocumentDirectory = await getApplicationDocumentsDirectory(); // Get the app's document directory
  Hive.init(appDocumentDirectory.path); // Initialize Hive with the app's document directory path
  Hive.registerAdapter(MovieDataAdapter()); // Register the MovieData adapter

  // Check if the user has seen the onboarding
  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
 
  // Run the app
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ProfileViewModel>(
          create: (_) => ProfileViewModel()
            ..getProfile()
            ..getAllFavorites()
            ..loadHistory(),
        ),
        BlocProvider<LanguageCubit>(
          create: (_) => LanguageCubit(),
        ),
      ],
      child: MyApp(showOnboarding: !seenOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;
  const MyApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp(
          // Use AppLocalizations to configure the correct localization
          locale: locale, 
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          debugShowCheckedModeBanner: false,

          // Use named routes to navigate to the different screens
          initialRoute: showOnboarding ? AppRoutes.onboarding1 : AppRoutes.login,
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

          // Use light and dark themes
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
        );
      },
    );
  }
}
