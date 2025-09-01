import 'package:movies_app/models/user_response.dart';

abstract class ProfileStates {}

class ProfileInitialState extends ProfileStates {}

class ProfileLoadingState extends ProfileStates {}

class ProfileErrorState extends ProfileStates {
  final String errorMessage;
  ProfileErrorState(this.errorMessage);
}

class ProfileSuccessState extends ProfileStates {
  User user;
  String successMessage;
  ProfileSuccessState(this.successMessage, this.user);
}
