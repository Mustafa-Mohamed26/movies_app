import 'package:movies_app/models/favorite_response.dart';
import 'package:movies_app/models/user_response.dart';

abstract class ProfileStates {}

class ProfileInitialState extends ProfileStates {}

class ProfileLoadingState extends ProfileStates {}

class ProfileErrorState extends ProfileStates {
  final String errorMessage;
  ProfileErrorState(this.errorMessage);
}

class ProfileSuccessState extends ProfileStates {
  final User? user;
  final List<MovieData>? movies;
  final String? successMessage;

  ProfileSuccessState({
    this.successMessage,
    this.user,
    this.movies,
  });

  ProfileSuccessState copyWith({
    User? user,
    List<MovieData>? movies,
    String? successMessage,
  }) {
    return ProfileSuccessState(
      user: user ?? this.user,
      movies: movies ?? this.movies,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

