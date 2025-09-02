import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/api/api_manager.dart';
import 'package:movies_app/models/update_request.dart';
import 'package:movies_app/ui/home/tabs/profile/bloc/profile_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel extends Cubit<ProfileStates> {
  ProfileViewModel() : super(ProfileInitialState());

  // controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // reset password controllers
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // GlobalKey for the form state
  var formKey = GlobalKey<FormState>();

  // GlobalKey for the reset password form state
  var resetPasswordFormKey = GlobalKey<FormState>();

  // selected avatar index
  int selectedAvatarIndex = 0;

  void getProfile() async {
    try {
      emit(ProfileLoadingState());
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      var response = await ApiManager.getProfile(token: token ?? '');
      if (response?.message != "Profile fetched successfully") {
        emit(ProfileErrorState(response?.message ?? "Error"));
        return;
      }
      if (response?.user == null) {
        emit(ProfileErrorState("User data is missing"));
        return;
      }
      emit(
        ProfileSuccessState(
          successMessage: response?.message ?? "Success",
          user: response?.user,
        ),
      );
      nameController.text = response?.user?.name ?? '';
      phoneController.text = response?.user?.phone ?? '';
      selectedAvatarIndex = response?.user?.avaterId ?? 0;
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
  }

  void updateProfile() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(ProfileLoadingState());

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');

      var response = await ApiManager.updateProfile(
        token: token ?? '',
        updateRequest: UpdateRequest(
          name: nameController.text,
          phone: phoneController.text,
          avaterId: selectedAvatarIndex,
        ),
      );

      if (response?.message != "Profile updated successfully") {
        emit(ProfileErrorState(response?.message ?? "Error"));
        return;
      }

      emit(ProfileSuccessState(successMessage: response?.message ?? "Success"));
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
  }

  void deleteProfile() async {
    emit(ProfileLoadingState());
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');

      if (token == null || token.isEmpty) {
        emit(ProfileErrorState("Token not found"));
        return;
      }

      var response = await ApiManager.deleteProfile(token: token);

      if (response == null) {
        emit(ProfileErrorState("No response from server"));
        return;
      }

      if (response.message != "Profile deleted successfully") {
        emit(ProfileErrorState(response.message ?? "Error"));
        return;
      }

      // ✅ remove token from shared preferences
      await pref.remove('token');

      emit(ProfileSuccessState(successMessage: response.message ?? "Success"));
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
  }

  void resetPassword() async {
    if (!(resetPasswordFormKey.currentState?.validate() ?? false)) {
      return;
    }

    emit(ProfileLoadingState());
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');

      if (token == null || token.isEmpty) {
        emit(ProfileErrorState("User not logged in or token missing"));
        return;
      }

      final response = await ApiManager.resetPassword(
        token: token,
        oldPassword: oldPasswordController.text.trim(),
        newPassword: passwordController.text.trim(),
      );

      if (response == null) {
        emit(ProfileErrorState("No response from server"));
        return;
      }

      if (response.message != "Password updated successfully") {
        emit(ProfileErrorState(response.message ?? "Error"));
        return;
      }

      emit(ProfileSuccessState(successMessage: response.message ?? "Success"));

      // Clear the password fields after successful reset
      oldPasswordController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    } catch (e) {
      emit(ProfileErrorState("Error: $e"));
    }
  }
}
