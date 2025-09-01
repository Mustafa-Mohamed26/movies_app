import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/api/api_manager.dart';
import 'package:movies_app/ui/home/tabs/profile/bloc/profile_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel extends Cubit<ProfileStates> {
  ProfileViewModel() : super(ProfileInitialState());

  void getProfile() async{
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
      emit(ProfileSuccessState(response?.message ?? "Success", response!.user!));
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
  }
}
