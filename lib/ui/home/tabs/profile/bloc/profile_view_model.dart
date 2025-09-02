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

  // GlobalKey for the form state
  var formKey = GlobalKey<FormState>();

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
    if (!formKey.currentState!.validate()) return;
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
      print(
        UpdateRequest(
          name: nameController.text,
          phone: phoneController.text,
          avaterId: selectedAvatarIndex,
        ).toJson(),
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
}
