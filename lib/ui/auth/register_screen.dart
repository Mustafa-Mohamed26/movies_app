import 'package:carousel_slider/carousel_slider.dart';
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

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<String> avatarList = [
    AppAssets.avatar1,
    AppAssets.avatar2,
    AppAssets.avatar3,
    AppAssets.avatar4,
    AppAssets.avatar5,
    AppAssets.avatar6,
    AppAssets.avatar7,
    AppAssets.avatar8,
    AppAssets.avatar9,
  ];

  // controllers
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  // GlobalKey for the form state
  var formKey = GlobalKey<FormState>();

  // State variables for password visibility
  // These variables control whether the password and re-password fields are visible or hidden
  bool isPasswordVisible = false;
  bool isRePasswordVisible = false;

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
      appBar: AppBar(title: Text("Register")),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                      ),
                      items: avatarList.map((avatarPath) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
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
                    children: [Text("Avatar", style: AppStyles.regular16white)],
                  ),
                  SizedBox(height: height * 0.01),
                  // CustomTextField for name input
                  CustomTextField(
                    controller: nameController,
                    colorBorderSide: AppColors.grey,
                    style: AppStyles.regular16white,
                    hintStyle: AppStyles.regular16white,
                    prefixIcon: Icon(
                      Icons.person,
                      size: 30,
                      color: AppColors.white,
                    ),
                    hintText: "Name",
                  ),
                  SizedBox(height: height * 0.02),
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

                  SizedBox(height: height * 0.02),
                  // CustomTextField for confirm password input
                  CustomTextField(
                    controller: confirmPasswordController,
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
                    hintText: "Confirm Password",
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
                    validate: (text) {
                      if (text == null || text.isEmpty) {
                        return "Please enter your password";
                      }
                      if (text.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      if (passwordController.text != text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  // CustomTextField for phone number input
                  CustomTextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    colorBorderSide: AppColors.grey,
                    style: AppStyles.regular16white,
                    hintStyle: AppStyles.regular16white,
                    prefixIcon: Icon(
                      Icons.phone,
                      size: 30,
                      color: AppColors.white,
                    ),
                    hintText: "Phone Number",
                  ),
                  SizedBox(height: height * 0.02),
                  CustomButton(
                    onPressed: () {},
                    text: "Login",
                    textStyle: AppStyles.regular20black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: AppStyles.regular14white,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.login,
                          );
                        },
                        child: Text("Login", style: AppStyles.bold14yellow),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  CustomSwitch(
                    value: isEnglish,
                    onToggle: (val) {
                      if (val) {
                        isEnglish = true;
                        setState(() {});
                      } else {
                        isEnglish = false;
                        setState(() {});
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
    );
  }
}
