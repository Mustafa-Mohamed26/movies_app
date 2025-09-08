import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/api/api_manager.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/models/login_request.dart';
import 'package:movies_app/models/user_request.dart';
import 'package:movies_app/ui/auth/cubit/auth_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends Cubit<AuthStates> {
  AuthViewModel() : super(AuthInitialState());
  // controllers
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  int? avaterId;

  // GlobalKey for the form state
  var formKey = GlobalKey<FormState>();

  void register(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      emit(AuthLoadingState());
      try {
        var response = await ApiManager.register(
          UserRequest(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
            confirmPassword: confirmPasswordController.text,
            phone: phoneController.text,
            avaterId: avaterId,
          ),
        );
        if (response?.message != "User created successfully") {
          emit(AuthErrorState(errorMessage: response?.message ?? AppLocalizations.of(context)!.error));
          return;
        }
        emit(
          AuthSuccessState(
            successMessage: response?.message ?? AppLocalizations.of(context)!.auth_view_model_login_success,
            user: response?.user,
          ),
        );
      } catch (e) {
        emit(AuthErrorState(errorMessage: e.toString()));
      }
    }
  }

  void login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        emit(AuthLoadingState());
        var response = await ApiManager.login(
          LoginRequest(
            email: emailController.text,
            password: passwordController.text,
          ),
        );
        if (response?.message != "Success Login") {
          emit(AuthErrorState(errorMessage: response?.message ?? AppLocalizations.of(context)!.error));
          return;
        }
        if (response?.message == "Success Login") {
          // save token in shared preferences
          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.clear();
          await pref.setString('token', response?.token ?? '');
          emit(
            AuthSuccessState(
              successMessage: response?.message ?? AppLocalizations.of(context)!.auth_view_model_login_success,
            ),
          );
        }
      } catch (e) {
        emit(AuthErrorState(errorMessage: e.toString()));
      }
    }
  }
}
