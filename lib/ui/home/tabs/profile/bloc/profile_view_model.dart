import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:movies_app/api/api_manager.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/models/movie_data.dart';
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

  void getProfile({BuildContext? context }) async {
    try {
      emit(ProfileLoadingState());
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      var response = await ApiManager.getProfile(token: token ?? '');
      await pref.setString('userId', "${response?.user?.sId}");
      loadHistory();
      getAllFavorites(context: context!);
      if (response?.message != "Profile fetched successfully") {
        emit(ProfileErrorState(response?.message ?? AppLocalizations.of(context)!.error));
        return;
      }
      
      if (response?.user == null) {
        emit(ProfileErrorState(response?.message ?? AppLocalizations.of(context)!.profile_view_model_user_missing));
        return;
      }

      if (state is ProfileSuccessState) {
        final currentState = state as ProfileSuccessState;
        emit(
          currentState.copyWith(
            user: response?.user,
            successMessage: response?.message,
          ),
        );
      } else {
        emit(
          ProfileSuccessState(
            successMessage: response?.message,
            user: response?.user,
          ),
        );
      }

      nameController.text = response?.user?.name ?? '';
      phoneController.text = response?.user?.phone ?? '';
      selectedAvatarIndex = response?.user?.avaterId ?? 0;
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
  }

  void updateProfile({BuildContext? context}) async {
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
        emit(ProfileErrorState(response?.message ?? AppLocalizations.of(context!)!.error));
        return;
      }

      if (state is ProfileSuccessState) {
        final currentState = state as ProfileSuccessState;
        emit(currentState.copyWith(successMessage: response?.message));
      } else {
        emit(ProfileSuccessState(successMessage: response?.message));
      }
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
  }

  void deleteProfile({BuildContext? context}) async {
    emit(ProfileLoadingState());
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');

      if (token == null || token.isEmpty) {
        emit(ProfileErrorState(AppLocalizations.of(context!)!.profile_view_model_token_not_found));
        return;
      }

      var response = await ApiManager.deleteProfile(token: token);

      if (response == null) {
        emit(ProfileErrorState(AppLocalizations.of(context!)!.profile_view_model_no_response));
        return;
      }

      if (response.message != "Profile deleted successfully") {
        emit(ProfileErrorState(response.message ?? AppLocalizations.of(context!)!.error));
        return;
      }

      // ✅ remove token from shared preferences
      await pref.remove('token');

      if (state is ProfileSuccessState) {
        final currentState = state as ProfileSuccessState;
        emit(currentState.copyWith(successMessage: response.message));
      } else {
        emit(ProfileSuccessState(successMessage: response.message));
      }
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
  }

  void resetPassword({BuildContext? context}) async {
    if (!(resetPasswordFormKey.currentState?.validate() ?? false)) {
      return;
    }

    emit(ProfileLoadingState());
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');

      if (token == null || token.isEmpty) {
        emit(ProfileErrorState(AppLocalizations.of(context!)!.profile_view_model_token_not_found));
        return;
      }

      final response = await ApiManager.resetPassword(
        token: token,
        oldPassword: oldPasswordController.text.trim(),
        newPassword: passwordController.text.trim(),
      );

      if (response == null) {
        emit(ProfileErrorState(AppLocalizations.of(context!)!.profile_view_model_no_response));
        return;
      }

      if (response.message != "Password updated successfully") {
        emit(ProfileErrorState(response.message ?? AppLocalizations.of(context!)!.error));
        return;
      }

      if (state is ProfileSuccessState) {
        final currentState = state as ProfileSuccessState;
        emit(currentState.copyWith(successMessage: response.message));
      } else {
        emit(ProfileSuccessState(successMessage: response.message));
      }

      // Clear the password fields after successful reset
      oldPasswordController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    } catch (e) {
      emit(ProfileErrorState("${AppLocalizations.of(context!)!.error} $e"));
    }
  }

  void getAllFavorites({BuildContext? context}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      var response = await ApiManager.getAllFavorites(token: token ?? '');

      if (response?.movies == null) {
        emit(ProfileErrorState(response?.message ?? AppLocalizations.of(context!)!.error));
        return;
      }

      if (state is ProfileSuccessState) {
        final currentState = state as ProfileSuccessState;
        emit(currentState.copyWith(movies: response!.movies));
      } else {
        emit(ProfileSuccessState(movies: response!.movies));
      }
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
  }

  void loadHistory() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? sId = pref.getString('userId');
      var box = await Hive.openBox<MovieData>(sId ?? '');
      var historyMovies = box.values.toList();
      await box.close();

      if (state is ProfileSuccessState) {
        final currentState = state as ProfileSuccessState;
        emit(currentState.copyWith(historyMovies: historyMovies));
      } else {
        emit(ProfileSuccessState(historyMovies: historyMovies));
      }
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
  }
}
