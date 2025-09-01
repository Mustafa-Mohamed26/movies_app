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
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController(text: "mustafa1234@gmail.com");

  TextEditingController passwordController = TextEditingController(text: "esayhya73M@");

  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

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

  String? emailValidator(String? text) {
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
  }

  String? passwordValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter your password";
    }
    // Check minimum length
    if (text.length < 8) {
      return "Password must be at least 8 characters";
    }
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(text)) {
      return "Password must contain at least one uppercase letter";
    }
    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(text)) {
      return "Password must contain at least one special character";
    }
    return null;
  }

  String? confirmPasswordValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter your password";
    }
    // Check minimum length
    if (text.length < 8) {
      return "Password must be at least 8 characters";
    }
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(text)) {
      return "Password must contain at least one uppercase letter";
    }
    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(text)) {
      return "Password must contain at least one special character";
    }
    // Check if it matches the original password
    if (passwordController.text != text) {
      return "Passwords do not match";
    }
    return null;
  }

  String? phoneValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter your phone number";
    }

    // Check if the phone number is valid
    final phoneRegex = RegExp(r'^(?:\+20\d{10}|01\d{9})$');

    if (!phoneRegex.hasMatch(text)) {
      return "Please enter a valid phone number (e.g. +2011xxxxxxxx or 011xxxxxxxx)";
    }

    return null;
  }
}
