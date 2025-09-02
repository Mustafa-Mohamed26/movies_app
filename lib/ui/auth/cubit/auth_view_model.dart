import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/api/api_manager.dart';
import 'package:movies_app/models/login_request.dart';
import 'package:movies_app/models/user_request.dart';
import 'package:movies_app/ui/auth/cubit/auth_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends Cubit<AuthStates> {
  AuthViewModel() : super(AuthInitialState());
  // controllers
  TextEditingController nameController = TextEditingController(text: "mustafa");

  TextEditingController emailController = TextEditingController(text: "mustafa1234@gmail.com");

  TextEditingController passwordController = TextEditingController(text: "esayhya73M@");

  TextEditingController confirmPasswordController = TextEditingController(text: "esayhya73M@");

  TextEditingController phoneController = TextEditingController(text: "+201234567899");

  int? avaterId;

  // GlobalKey for the form state
  var formKey = GlobalKey<FormState>();

  void register() async {
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
          emit(AuthErrorState(errorMessage: response?.message ?? "Error"));
          return;
        }
        emit(
          AuthSuccessState(
            successMessage: response?.message ?? "success",
            user: response?.user,
          ),
        );
      } catch (e) {
        emit(AuthErrorState(errorMessage: e.toString()));
      }
    }
  }

  void login() async {
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
          emit(AuthErrorState(errorMessage: response?.message ?? "Error"));
          return;
        }
        if (response?.message == "Success Login") {
          // save token in shared preferences
          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.clear();
          await pref.setString('token', response?.token ?? '');
          emit(
            AuthSuccessState(
              successMessage: response?.message ?? "success",
            ),
          );
        }
      } catch (e) {
        emit(AuthErrorState(errorMessage: e.toString()));
      }
    }
  }
}
