import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/ui/home/cubit/movie_list_states.dart';
import 'package:movies_app/ui/home/cubit/movie_list_view_model.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_constants.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/widgets/custom_card.dart';

class HomeTab extends StatefulWidget {
  final Function(String genre)? onSeeMore; // 👈 نستقبل callback

  const HomeTab({super.key, this.onSeeMore});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  MovieListViewModel allMoviesViewModel = MovieListViewModel();
  MovieListViewModel genreMoviesViewModel = MovieListViewModel();

  int currentIndex = 0;
  String selectedGenre = "Action";

  @override
  void initState() {
    super.initState();

    // ✅ random genre once when HomeTab opens
    selectedGenre =
        AppConstants.genres[Random().nextInt(AppConstants.genres.length)];

    allMoviesViewModel.loadMoviesList(limit: 20, page: 1); // all movies
    genreMoviesViewModel.loadMoviesList(
      genre: selectedGenre,
      limit: 20,
      page: 1,
    ); // genre movies
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BlocBuilder<MovieListViewModel, MovieListStates>(
        bloc: allMoviesViewModel,
        builder: (context, state) {
          if (state is MovieListErrorState) {
            return Center(
              child: Text(state.errorMessage, style: AppStyles.regular20white),
            );
          }

          if (state is MovieListSuccessState) {
            var movies = state.moviesList;

            return Stack(
              children: [
                // 🎬 Background
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: Container(
                    key: ValueKey<String>(
                      "${currentIndex}_${movies[currentIndex].largeCoverImage ?? "default"}",
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            (movies[currentIndex].largeCoverImage != null &&
                                movies[currentIndex]
                                    .largeCoverImage!
                                    .isNotEmpty)
                            ? CachedNetworkImageProvider(
                                movies[currentIndex].largeCoverImage!,
                              )
                            : AssetImage(AppAssets.test1) as ImageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),

                // 🎬 Foreground
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.darkBlack80,
                        AppColors.darkBlack60,
                        AppColors.black,
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.02),
                        Image.asset(AppAssets.availableNow),
                        SizedBox(height: height * 0.02),

                        // ✅ Carousel for All Movies with pagination
                        CarouselSlider(
                          options: CarouselOptions(
                            enlargeCenterPage: true,
                            autoPlay: true,
                            height: height * 0.35,
                            viewportFraction: 0.55,
                            enlargeFactor: 0.35,
                            onPageChanged: (index, reason) {
                              setState(() => currentIndex = index);

                              // ✅ pagination trigger for all movies
                              if (index >= movies.length - 3 &&
                                  !allMoviesViewModel.isLoadingMore) {
                                allMoviesViewModel.loadMoviesList(
                                  limit: 20,
                                  page: allMoviesViewModel.currentPage,
                                  isLoadMore: true,
                                );
                              }
                            },
                          ),
                          items: movies.map((movie) {
                            return CustomCard(
                              image: movie.largeCoverImage ?? "",
                              rate: movie.rating ?? 0.0,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.details,
                                  arguments: movie.id,
                                );
                              },
                            );
                          }).toList(),
                        ),

                        if (allMoviesViewModel.isLoadingMore)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: AppColors.yellow,
                            ),
                          ),

                        SizedBox(height: height * 0.02),
                        Image.asset(AppAssets.watchNow),
                        SizedBox(height: height * 0.02),

                        // ✅ Dynamic Genre Header
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedGenre,
                                style: AppStyles.regular16white,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // 👈 نستدعي الـ callback ونبعت genre
                                      widget.onSeeMore?.call(selectedGenre);
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "See More",
                                          style: AppStyles.regular16yellow,
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: AppColors.yellow,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // ✅ Genre Movies with pagination
                        BlocBuilder<MovieListViewModel, MovieListStates>(
                          bloc: genreMoviesViewModel,
                          builder: (context, genreState) {
                            if (genreState is MovieListSuccessState) {
                              var genreMovies = genreState.moviesList;
                              return SizedBox(
                                height: height * 0.22,
                                child: NotificationListener<ScrollNotification>(
                                  onNotification: (scrollInfo) {
                                    if (scrollInfo.metrics.pixels >=
                                            scrollInfo.metrics.maxScrollExtent -
                                                100 &&
                                        !genreMoviesViewModel.isLoadingMore) {
                                      genreMoviesViewModel.loadMoviesList(
                                        genre: selectedGenre,
                                        limit: 20,
                                        page: genreMoviesViewModel.currentPage,
                                        isLoadMore: true,
                                      );
                                    }
                                    return false;
                                  },
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    itemCount: genreMovies.length,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(width: width * 0.03),
                                    itemBuilder: (context, index) {
                                      return AspectRatio(
                                        aspectRatio: 2 / 3,
                                        child: CustomCard(
                                          image:
                                              genreMovies[index]
                                                  .largeCoverImage ??
                                              "",
                                          rate:
                                              genreMovies[index].rating ?? 0.0,
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes.details,
                                              arguments: genreMovies[index].id,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                            if (genreState is MovieListErrorState) {
                              return Text(
                                genreState.errorMessage,
                                style: AppStyles.regular16white,
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.yellow,
                              ),
                            );
                          },
                        ),

                        if (genreMoviesViewModel.isLoadingMore)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: AppColors.yellow,
                            ),
                          ),

                        SizedBox(height: height * 0.03),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(color: AppColors.yellow),
          );
        },
      ),
    );
  }
}
