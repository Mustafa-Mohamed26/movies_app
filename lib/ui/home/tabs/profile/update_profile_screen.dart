import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_resources.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/widgets/custom_button.dart';
import 'package:movies_app/widgets/custom_text_form_field.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  // controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // GlobalKey for the form state
  var formKey = GlobalKey<FormState>();

  // selected avatar index
  int selectedAvatarIndex = 0;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Pick avatar")),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: AppColors.black,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                              itemCount: AppResources.avatarList.length,
                              itemBuilder: (context, index) {
                                final avatarPath =
                                    AppResources.avatarList[index];
                                final isSelected = selectedAvatarIndex == index;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedAvatarIndex = index;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.yellow
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.yellow,
                                        width: 1,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        avatarPath,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(
                        AppResources.avatarList[selectedAvatarIndex],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
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
              // CustomTextField for phone number input
              CustomTextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                colorBorderSide: AppColors.grey,
                style: AppStyles.regular16white,
                hintStyle: AppStyles.regular16white,
                prefixIcon: Icon(Icons.phone, size: 30, color: AppColors.white),
                hintText: "Phone Number",
              ),
              SizedBox(height: height * 0.02),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Reset Password",
                      style: AppStyles.regular20white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              CustomButton(
                onPressed: () {},
                text: "Delete Account",
                textStyle: AppStyles.regular20white,
                backgroundColor: AppColors.red,
                borderColorSide: AppColors.red,
              ),
              SizedBox(height: height * 0.02),
              CustomButton(
                onPressed: () {},
                text: "Update data",
                textStyle: AppStyles.regular20black,
              ),
              SizedBox(height: height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
