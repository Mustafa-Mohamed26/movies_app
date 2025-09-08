import 'package:colorful_iconify_flutter/icons/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/ui/auth/cubit/auth_states.dart';
import 'package:movies_app/ui/auth/cubit/auth_view_model.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/app_validators.dart';
import 'package:movies_app/utils/dialog_utils.dart';
import 'package:movies_app/utils/language_cubit.dart';
import 'package:movies_app/widgets/custom_button.dart';
import 'package:movies_app/widgets/custom_switch.dart';
import 'package:movies_app/widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthViewModel authViewModel = AuthViewModel();
  // Variable to track if the password is visible
  bool isPasswordVisible = false;
  bool isEnglish = true;

  @override
  Widget build(BuildContext context) {
    var languageCubit = context.read<LanguageCubit>();
    var width = MediaQuery.of(
      context,
    ).size.width; // Get the width of the screen
    var height = MediaQuery.of(
      context,
    ).size.height; // Get the height of the screen
    return BlocListener<AuthViewModel, AuthStates>(
      bloc: authViewModel, // Use the AuthViewModel
      // Listen for changes in the AuthStates
      listener: (BuildContext context, AuthStates state) {
        if (state is AuthLoadingState) {
          DialogUtils.showLoading(context: context, loadingText: AppLocalizations.of(context)!.loading);
        } else if (state is AuthSuccessState) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: state.successMessage ?? "",
            posActionName: AppLocalizations.of(context)!.ok,
            posAction: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (_) => false,
            ),
          );
        } else if (state is AuthErrorState) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: state.errorMessage,
            title: AppLocalizations.of(context)!.error,
            posActionName: AppLocalizations.of(context)!.ok,
            posAction: () => Navigator.pop(context),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(AppAssets.logo, height: height * 0.25),

                  // Form widget for email and password inputs
                  // This form contains two text fields for email and password
                  Form(
                    key: authViewModel.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // CustomTextField for email input
                        CustomTextField(
                          controller: authViewModel.emailController,
                          keyboardType: TextInputType.emailAddress,
                          colorBorderSide: AppColors.grey,
                          style: AppStyles.regular16white,
                          hintStyle: AppStyles.regular16white,

                          prefixIcon: Icon(
                            Icons.email_rounded,
                            size: 30,
                            color: AppColors.white,
                          ),
                          hintText: AppLocalizations.of(context)!.email,

                          // Validate the email input
                          // Check if the email is empty or not valid
                          validate: (text) =>
                              AppValidators.emailValidator(text, context),
                        ),
                        SizedBox(height: height * 0.02),

                        //CustomTextField for password input
                        CustomTextField(
                          controller: authViewModel.passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          colorBorderSide: AppColors.grey,
                          style: AppStyles.regular16white,
                          hintStyle: AppStyles.regular16white,
                          obscureText: !isPasswordVisible,
                          obscuringCharacter: "*",
                          prefixIcon: Icon(
                            Icons.lock,
                            size: 30,
                            color: AppColors.white,
                          ),
                          hintText: AppLocalizations.of(context)!.password,

                          // Suffix icon for toggling password visibility
                          // This icon will change based on the isPasswordVisible state
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),

                          // Validate the password input
                          // Check if the password is empty or less than 6 characters
                          validate: (text) =>
                              AppValidators.passwordValidator(text, context),
                        ),
                        SizedBox(height: height * 0.01),

                        // Row for forget password link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // TextButton for "Forget Password"
                            // This button is used to navigate to the forget password screen
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.forgotPassword,
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.forget_password,
                                style: AppStyles.regular14yellow,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.01),

                        // CustomElevatedButton for login action
                        // This button is used to trigger the login function
                        CustomButton(
                          onPressed: () {
                            authViewModel.login(context);
                          },
                          text: AppLocalizations.of(context)!.login,
                          textStyle: AppStyles.regular20black,
                        ),
                        SizedBox(height: height * 0.01),

                        // Row for account creation link
                        // This row contains a text and a button to navigate to the registration screen
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.donot_have_account,
                              style: AppStyles.regular14white,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.register,
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.create_account,
                                style: AppStyles.bold14yellow,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.02),

                        // // Divider with "Or" text in the middle
                        // // This divider separates the login form from the Google login button
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Divider(
                        //         thickness: 2,
                        //         color: AppColors.yellow,
                        //         indent: width * 0.1,
                        //         endIndent: width * 0.05,
                        //       ),
                        //     ),
                        //     Text(AppLocalizations.of(context)!.or, style: AppStyles.regular16yellow),
                        //     Expanded(
                        //       child: Divider(
                        //         thickness: 2,
                        //         color: AppColors.yellow,
                        //         indent: width * 0.05,
                        //         endIndent: width * 0.1,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: height * 0.02),

                        // // CustomElevatedButton for Google login
                        // // This button is used to trigger the Google login function
                        // CustomButton(
                        //   text: AppLocalizations.of(context)!.login_with_google,
                        //   backgroundColor: AppColors.yellow,
                        //   borderColorSide: AppColors.yellow,
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   hasIcon: true,
                        //   iconWidget: Image.asset(AppAssets.google),
                        //   textStyle: AppStyles.regular16black,
                        //   onPressed: () {
                        //     //  Google login
                        //   },
                        // ),
                        //SizedBox(height: height * 0.02),

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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
