import 'package:movies_app/models/user_response.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthErrorState extends AuthStates {
  String errorMessage;
  AuthErrorState({required this.errorMessage});
}

class AuthSuccessState extends AuthStates {
  User? user;
  String? successMessage;
  String? token;
  AuthSuccessState({this.successMessage, this.user, this.token});
}
