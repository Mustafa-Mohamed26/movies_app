import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/api/api_manager.dart';
import 'package:movies_app/ui/home/cubit/movie_list_states.dart';

class MovieListViewModel extends Cubit<MovieListStates> {
  MovieListViewModel() : super(MovieListInitialState());

  TextEditingController searchController = TextEditingController();

  void loadMoviesList({String? genre, int? limit, int? page, String? query}) async {
    // Emit loading state
    emit(MovieListLoadingState());
    try {
      var response = await ApiManager.getListOfMovies(
        genre: genre,
        limit: limit,
        page: page,
        query: searchController.text,
      );
      
      // Check if response status is not "ok"
      if (response?.status != "ok") {
        emit(
          MovieListErrorState(errorMessage: response?.statusMessage ?? "Error"),
        );
        return;
      }
      // Check if movies list is empty
      if (response!.data!.movies!.isEmpty) {
        emit(MovieListEmptyState());
        return;
      }
      // Emit success state with movies list
      emit(MovieListSuccessState(moviesList: response.data?.movies ?? []));
    } catch (e) {
      emit(MovieListErrorState(errorMessage: e.toString()));
    }
  }
}
