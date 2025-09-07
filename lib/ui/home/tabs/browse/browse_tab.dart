import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/ui/home/cubit/movie_list_states.dart';
import 'package:movies_app/ui/home/cubit/movie_list_view_model.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_constants.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/widgets/custom_2column_grid_view.dart';
import 'package:movies_app/widgets/custom_genres_tab_item.dart';

class BrowseTab extends StatefulWidget {
  final String? selectedGenre; // 👈 نستقبل genre من HomeScreen

  const BrowseTab({super.key, this.selectedGenre});

  @override
  State<BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  MovieListViewModel movieListViewModel = MovieListViewModel();
  late String selectedGenre; // 👈 لازم نعملها late

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // ✅ لو جاي من HomeTab نستعمله، لو مش جاي نبدأ بـ Action
    selectedGenre = widget.selectedGenre ?? "Action";

    // تحميل أول صفحة
    movieListViewModel.loadMoviesList(
      genre: selectedGenre,
      limit: 20,
      page: 1,
    );

    // Pagination scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !movieListViewModel.isLoadingMore) {
        movieListViewModel.loadMoviesList(
          genre: selectedGenre,
          limit: 20,
          page: movieListViewModel.currentPage,
          isLoadMore: true,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: height * 0.02, left: width * 0.03),
          child: DefaultTabController(
            length: AppConstants.genres.length,
            initialIndex: AppConstants.genres.indexOf(selectedGenre), // 👈 يبدأ من genre الحالي
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelPadding: EdgeInsets.zero,
              indicatorColor: AppColors.transparent,
              dividerColor: AppColors.transparent,
              onTap: (index) {
                setState(() {
                  selectedGenre = AppConstants.genres[index];
                  movieListViewModel.loadMoviesList(
                    genre: selectedGenre,
                    limit: 20,
                    page: 1,
                  );
                });
              },
              tabs: AppConstants.genres.map((genreName) {
                return CustomGenresTabItem(
                  eventName: genreName,
                  isSelected: selectedGenre == genreName,
                  selectedBgColor: AppColors.yellow,
                  selectedTextStyle: AppStyles.bold20black,
                  unSelectedTextStyle: AppStyles.bold20yellow,
                  borderColor: AppColors.yellow,
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<MovieListViewModel, MovieListStates>(
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
                return Custom2columnGridView(
                  controller: _scrollController,
                  count: state.moviesList.length,
                  moviesList: state.moviesList,
                );
              }
              return const Center(
                child: CircularProgressIndicator(color: AppColors.yellow),
              );
            },
          ),
        ),
        if (movieListViewModel.isLoadingMore)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(color: AppColors.yellow),
          ),
      ],
    );
  }
}
