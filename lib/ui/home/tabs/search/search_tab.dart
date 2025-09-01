import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/ui/home/cubit/movie_list_states.dart';
import 'package:movies_app/ui/home/cubit/movie_list_view_model.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/widgets/custom_2column_grid_view.dart';
import 'package:movies_app/widgets/custom_card.dart';
import 'package:movies_app/widgets/custom_text_form_field.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  MovieListViewModel movieListViewModel = MovieListViewModel();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: height * 0.02,
            left: width * 0.04,
            right: width * 0.04,
          ),
          child: CustomTextField(
            controller: movieListViewModel.searchController,
            colorBorderSide: AppColors.grey,
            style: AppStyles.regular16white,
            hintStyle: AppStyles.regular16white,
            prefixIcon: Image.asset(
              AppAssets.searchIcon,
              width: width * 0.05,
              height: height * 0.05,
            ),
            hintText: "Search",
            onChanged: (value) {
              movieListViewModel.loadMoviesList(
                limit: 50,
                page: 1,
                query: value,
              );
            },
          ),
        ),

        BlocBuilder<MovieListViewModel, MovieListStates>(
          bloc: movieListViewModel,
          builder: (context, state) {
            if (state is MovieListErrorState) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: AppStyles.regular20white,
                ),
              );
            }
            if (state is MovieListEmptyState) {
              return Center(
                child: Text("No Movies Found", style: AppStyles.regular20white),
              );
            }
            if (state is MovieListSuccessState) {
              return Expanded(
                child: Custom2columnGridView(
                  count: state.moviesList.length,
                  moviesList: state.moviesList,
                ),
              );
            }
            return Expanded(
              child: Center(
                child: Image.asset(
                  AppAssets.emptyListIcon,
                  width: width * 0.5,
                  height: height * 0.5,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
