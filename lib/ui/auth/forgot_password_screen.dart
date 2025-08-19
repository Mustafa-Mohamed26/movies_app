import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/widgets/custom_button.dart';
import 'package:movies_app/widgets/custom_text_form_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  // GlobalKey for the form state
  var formKey = GlobalKey<FormState>();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(AppAssets.forgotPassword),
              // CustomTextField for email input
              CustomTextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                colorBorderSide: AppColors.grey,
                style: AppStyles.regular16white,
                hintStyle: AppStyles.regular16white,

                prefixIcon: Icon(
                  Icons.email_rounded,
                  size: 30,
                  color: AppColors.white,
                ),
                hintText: "Email",

                // Validate the email input
                // Check if the email is empty or not valid
                validate: (text) {
                  if (text == null || text.isEmpty) {
                    return "Please enter your email";
                  }
                  final bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  ).hasMatch(text);
                  if (!emailValid) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ),
              SizedBox(height: height * 0.02),
              CustomButton(
                onPressed: () {},
                text: "Verify Email",
                textStyle: AppStyles.regular20black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
