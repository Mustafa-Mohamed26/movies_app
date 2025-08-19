import 'package:colorful_iconify_flutter/icons/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/widgets/custom_button.dart';
import 'package:movies_app/widgets/custom_switch.dart';
import 'package:movies_app/widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // controllers
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  // GlobalKey for the form state
  var formKey = GlobalKey<FormState>();

  // Variable to track if the password is visible
  bool isPasswordVisible = false;
  bool isEnglish = true;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(
      context,
    ).size.width; // Get the width of the screen
    var height = MediaQuery.of(
      context,
    ).size.height; // Get the height of the screen
    return Scaffold(
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
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                      //CustomTextField for password input
                      CustomTextField(
                        controller: passwordController,
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
                        hintText: "password",

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
                        validate: (text) {
                          if (text == null || text.isEmpty) {
                            return "Please enter your password";
                          }
                          if (text.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // TextButton for "Forget Password"
                          // This button is used to navigate to the forget password screen
                          TextButton(
                            onPressed: () {
                              //TODO: forget password
                            },
                            child: Text(
                              'Forget Password?',
                              style: AppStyles.regular14yellow,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.01),
                      // CustomElevatedButton for login action
                      // This button is used to trigger the login function
                      CustomButton(
                        onPressed: () {},
                        text: "Login",
                        textStyle: AppStyles.regular20black,
                      ),
                      SizedBox(height: height * 0.01),
                      // Row for account creation link
                      // This row contains a text and a button to navigate to the registration screen
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: AppStyles.regular14white,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.register);
                            },
                            child: Text(
                              "Create Account",
                              style: AppStyles.bold14yellow,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.02),
                      // Divider with "Or" text in the middle
                      // This divider separates the login form from the Google login button
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 2,
                              color: AppColors.yellow,
                              indent: width * 0.1,
                              endIndent: width * 0.05,
                            ),
                          ),
                          Text("OR", style: AppStyles.regular16yellow),
                          Expanded(
                            child: Divider(
                              thickness: 2,
                              color: AppColors.yellow,
                              indent: width * 0.05,
                              endIndent: width * 0.1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      // CustomElevatedButton for Google login
                      // This button is used to trigger the Google login function
                      CustomButton(
                        text: "Login with Google",
                        backgroundColor: AppColors.yellow,
                        borderColorSide: AppColors.yellow,
                        mainAxisAlignment: MainAxisAlignment.center,
                        hasIcon: true,
                        iconWidget: Image.asset(AppAssets.google),
                        textStyle: AppStyles.regular16black,
                        onPressed: () {
                          //  Google login
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      CustomSwitch(
                        value: isEnglish,
                        onToggle: (val) {
                          if (val) {
                            isEnglish = true;
                            setState(() {
                              
                            });
                          } else {
                            isEnglish = false;
                            setState(() {
                              
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
    );
  }
}
