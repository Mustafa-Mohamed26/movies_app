import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/bloc/user_cubit/user_states.dart';
import 'package:movies_app/models/user_response.dart';


class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitial());

  // save user and token initially
  void setUserAndToken(User user, String token) {
    emit(UserLoaded(user: user, token: token));
  }

  // save user only
  void setUser(User? user) {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      emit(
        currentState.copyWith(user: user),
      );
    }
  }

  // save token only
  void setToken(String? token) {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      emit(
        currentState.copyWith(token: token),
      );
    }
  }

  // update only the user
  void updateUser(User newUser) {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      emit(
        currentState.copyWith(user: newUser),
      );
    }
  }

  // update only the token
  void updateToken(String newToken) {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      emit(
        currentState.copyWith(token: newToken),
      );
    }
  }

  // get user and token
  User? get currentUser =>
      state is UserLoaded ? (state as UserLoaded).user : null;

  String? get currentToken =>
      state is UserLoaded ? (state as UserLoaded).token : null;
}
