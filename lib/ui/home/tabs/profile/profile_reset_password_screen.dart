import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/ui/home/tabs/profile/bloc/profile_states.dart';
import 'package:movies_app/ui/home/tabs/profile/bloc/profile_view_model.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/app_validators.dart';
import 'package:movies_app/utils/dialog_utils.dart';
import 'package:movies_app/widgets/custom_button.dart';
import 'package:movies_app/widgets/custom_text_form_field.dart';

class ProfileResetPasswordScreen extends StatefulWidget {
  const ProfileResetPasswordScreen({super.key});

  @override
  State<ProfileResetPasswordScreen> createState() =>
      _ProfileResetPasswordScreenState();
}

class _ProfileResetPasswordScreenState
    extends State<ProfileResetPasswordScreen> {
  late ProfileViewModel profileViewModel;
  // State variables for password visibility
  // These variables control whether the password and re-password fields are visible or hidden
  bool isOldPasswordVisible = false;
  bool isPasswordVisible = false;
  bool isRePasswordVisible = false;

  @override
  void initState() {
    super.initState();
    profileViewModel = context.read<ProfileViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocListener<ProfileViewModel, ProfileStates>(
      listener: (context, state) {
        if (state is ProfileLoadingState) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showLoading(context: context, loadingText: AppLocalizations.of(context)!.loading);
        } else if (state is ProfileSuccessState) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: state.successMessage ?? AppLocalizations.of(context)!.success,
            posActionName: AppLocalizations.of(context)!.ok,
            posAction: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (_) => false,
              );
            },
          );
        } else if (state is ProfileErrorState) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: state.errorMessage,
            title: AppLocalizations.of(context)!.error,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.reset_password)),
        body: Form(
          key: profileViewModel.resetPasswordFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(AppAssets.forgotPassword),

                //CustomTextField for old password input
                CustomTextField(
                  controller: profileViewModel.oldPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  colorBorderSide: AppColors.grey,
                  style: AppStyles.regular16white,
                  hintStyle: AppStyles.regular16white,
                  obscureText: !isOldPasswordVisible,
                  obscuringCharacter: "*",
                  prefixIcon: Icon(
                    Icons.lock,
                    size: 30,
                    color: AppColors.white,
                  ),
                  hintText: AppLocalizations.of(context)!.old_password,

                  // Suffix icon for toggling password visibility
                  // This icon will change based on the isPasswordVisible state
                  suffixIcon: IconButton(
                    icon: Icon(
                      isOldPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isOldPasswordVisible = !isOldPasswordVisible;
                      });
                    },
                  ),

                  // Validate the password input
                  validate: (text) => AppValidators.passwordValidator(text, context),
                ),

                SizedBox(height: height * 0.02),

                //CustomTextField for password input
                CustomTextField(
                  controller: profileViewModel.passwordController,
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
                  validate: (text) => AppValidators.passwordValidator(text, context),
                ),
                SizedBox(height: height * 0.02),

                // CustomTextField for confirm password input
                CustomTextField(
                  controller: profileViewModel.confirmPasswordController,
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
                  validate: (text) => AppValidators.confirmPasswordValidator(
                    text,
                    profileViewModel.passwordController.text,context
                  ),
                ),

                Spacer(),

                CustomButton(
                  onPressed: () {
                    profileViewModel.resetPassword(context: context);
                  },
                  text: AppLocalizations.of(context)!.reset_password,
                  textStyle: AppStyles.regular20black,
                ),

                SizedBox(height: height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
