import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/ui/home/tabs/profile/bloc/profile_states.dart';
import 'package:movies_app/ui/home/tabs/profile/bloc/profile_view_model.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_resources.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/dialog_utils.dart';
import 'package:movies_app/widgets/custom_button.dart';
import 'package:movies_app/widgets/custom_text_form_field.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late ProfileViewModel profileViewModel;

  bool isDeleted = false;

  @override
  void initState() {
    super.initState();
    profileViewModel = context.read<ProfileViewModel>();
  }

  @override
  void dispose() {
    super.dispose();
    profileViewModel.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return BlocListener<ProfileViewModel, ProfileStates>(
      listener: (context, state) {
        if (state is ProfileLoadingState) {
          DialogUtils.showLoading(context: context, loadingText: "Loading...");
        } else if (state is ProfileSuccessState) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: state.successMessage,
            posActionName: "OK",
            posAction: () {
              isDeleted
                  ? Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (result) => false,
                    )
                  : Navigator.pop(context);
            },
          );
        } else if (state is ProfileErrorState) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: state.errorMessage,
            title: "Error",
            posActionName: "Ok",
            posAction: () => Navigator.pop(context),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Pick avatar")),
        body: Form(
          key: profileViewModel.formKey,
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
                                  final isSelected =
                                      profileViewModel.selectedAvatarIndex ==
                                      index;

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        profileViewModel.selectedAvatarIndex =
                                            index;
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
                          AppResources.avatarList[profileViewModel
                              .selectedAvatarIndex],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                // CustomTextField for name input
                CustomTextField(
                  controller: profileViewModel.nameController,
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
                  controller: profileViewModel.phoneController,
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
                  onPressed: () {
                    isDeleted = true;
                    profileViewModel.deleteProfile();
                  },
                  text: "Delete Account",
                  textStyle: AppStyles.regular20white,
                  backgroundColor: AppColors.red,
                  borderColorSide: AppColors.red,
                ),
                SizedBox(height: height * 0.02),
                CustomButton(
                  onPressed: () {
                    isDeleted = false;
                    profileViewModel.updateProfile();
                  },
                  text: "Update data",
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
