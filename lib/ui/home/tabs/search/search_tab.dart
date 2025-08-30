import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/models/movie_details_response.dart';
import 'package:movies_app/ui/home/cubit/movie_list_states.dart';
import 'package:movies_app/ui/home/cubit/movie_list_view_model.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_styles.dart';
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
                child: Text(
                  "No Movies Found",
                  style: AppStyles.regular20white,
                ),
              );
            }
            if (state is MovieListSuccessState) {
              return Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                    vertical: height * 0.02,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: width * 0.05,
                    mainAxisSpacing: height * 0.02,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: state.moviesList.length,
                  itemBuilder: (context, index) {
                    final movie = state.moviesList[index];
                    return CustomCard(
                      image: (movie.mediumCoverImage?.isNotEmpty ?? false)
                          ? movie.mediumCoverImage!
                          : AppAssets.test1,
                      rate: movie.rating ?? 0.0,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.details,
                          arguments: movie.id,
                        );
                      },
                    );
                  },
                ),
              );
            }
            return SizedBox(
              height: height * 0.25,
              child: Center(
                child: Text(
                  "Start Searching",
                  style: AppStyles.regular20white,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
