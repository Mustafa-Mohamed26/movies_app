import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/api/api_manager.dart';
import 'package:movies_app/ui/home/cubit/movie_list_states.dart';

class MovieListViewModel extends Cubit<MovieListStates> {
  MovieListViewModel() : super(MovieListInitialState());

  void loadMoviesList({String? genre, int? limit, int? page}) async {
    emit(MovieListLoadingState());
    try {
      var response = await ApiManager.getListOfMovies(genre: genre, limit: limit, page: page);
      if (response?.status != "ok") {
        emit(
          MovieListErrorState(errorMessage: response?.statusMessage ?? "Error"),
        );
        return;
      }
      emit(MovieListSuccessState(moviesList: response?.data?.movies ?? []));
    } catch (e) {
      emit(MovieListErrorState(errorMessage: e.toString()));
    }
  }
}
