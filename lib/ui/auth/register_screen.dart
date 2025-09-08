import 'package:carousel_slider/carousel_slider.dart';
import 'package:colorful_iconify_flutter/icons/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/ui/auth/cubit/auth_states.dart';
import 'package:movies_app/ui/auth/cubit/auth_view_model.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_resources.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/app_validators.dart';
import 'package:movies_app/utils/dialog_utils.dart';
import 'package:movies_app/utils/language_cubit.dart';
import 'package:movies_app/widgets/custom_button.dart';
import 'package:movies_app/widgets/custom_switch.dart';
import 'package:movies_app/widgets/custom_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthViewModel authViewModel = AuthViewModel();

  // State variables for password visibility
  // These variables control whether the password and re-password fields are visible or hidden
  bool isPasswordVisible = false;
  bool isRePasswordVisible = false;

  bool isEnglish = true;

  @override
  void initState() {
    authViewModel.avaterId = 0;
    super.initState();
  }

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
          DialogUtils.showLoading(
            context: context,
            loadingText: AppLocalizations.of(context)!.loading,
          );
        } else if (state is AuthSuccessState) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: state.successMessage ?? "",
            title: AppLocalizations.of(
              context,
            )!.auth_view_model_register_success,
            posActionName: AppLocalizations.of(context)!.ok,
            posAction: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
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
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.register)),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: SingleChildScrollView(
              // Form widget for email and password inputs
              child: Form(
                key: authViewModel.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Avatar carousel
                    Padding(
                      padding: EdgeInsets.only(bottom: height * 0.03),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 120,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          viewportFraction: 0.33,
                          enlargeStrategy: CenterPageEnlargeStrategy.scale,
                          enlargeFactor: 0.35,
                          onPageChanged: (index, reason) {
                            setState(() {
                              authViewModel.avaterId = index;
                            });
                          },
                        ),
                        items: AppResources.avatarList.map((avatarPath) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: AssetImage(avatarPath),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.avater,
                          style: AppStyles.regular16white,
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.01),

                    // CustomTextField for name input
                    CustomTextField(
                      controller: authViewModel.nameController,
                      colorBorderSide: AppColors.grey,
                      style: AppStyles.regular16white,
                      hintStyle: AppStyles.regular16white,
                      prefixIcon: Icon(
                        Icons.person,
                        size: 30,
                        color: AppColors.white,
                      ),
                      hintText: AppLocalizations.of(context)!.name,
                    ),
                    SizedBox(height: height * 0.02),

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
                      validate: (text) => AppValidators.emailValidator(text,
                          context),
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
                      validate: (text) => AppValidators.passwordValidator(text, context),
                    ),

                    SizedBox(height: height * 0.02),

                    // CustomTextField for confirm password input
                    CustomTextField(
                      controller: authViewModel.confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      colorBorderSide: AppColors.grey,
                      style: AppStyles.regular16white,
                      hintStyle: AppStyles.regular16white,
                      obscureText: !isRePasswordVisible,
                      obscuringCharacter: "*",
                      prefixIcon: Icon(
                        Icons.lock,
                        size: 30,
                        color: AppColors.white,
                      ),
                      hintText: AppLocalizations.of(context)!.confirm_password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isRePasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isRePasswordVisible = !isRePasswordVisible;
                          });
                        },
                      ),
                      validate: (text) =>
                          AppValidators.confirmPasswordValidator(
                            text,
                            authViewModel.passwordController.text,
                            context,
                          ),
                    ),
                    SizedBox(height: height * 0.02),

                    // CustomTextField for phone number input
                    CustomTextField(
                      controller: authViewModel.phoneController,
                      keyboardType: TextInputType.phone,
                      colorBorderSide: AppColors.grey,
                      style: AppStyles.regular16white,
                      hintStyle: AppStyles.regular16white,
                      prefixIcon: Icon(
                        Icons.phone,
                        size: 30,
                        color: AppColors.white,
                      ),
                      hintText: AppLocalizations.of(context)!.phone_number,
                      validate: (text) =>
                          AppValidators.phoneValidator(text, context),
                    ),
                    SizedBox(height: height * 0.02),

                    // CustomButton for creating an account
                    CustomButton(
                      onPressed: () {
                        authViewModel.register(context);
                      },
                      text: AppLocalizations.of(context)!.create_account,
                      textStyle: AppStyles.regular20black,
                    ),

                    // Already have an account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.already_have_account,
                          style: AppStyles.regular14white,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.login,
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.login,
                            style: AppStyles.bold14yellow,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),

                    // CustomSwitch for language
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
            ),
          ),
        ),
      ),
    );
  }
}
