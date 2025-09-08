class EndPoints {
  // auth
  static String loginApi = "/auth/login";
  static String registerApi = "/auth/register";
  static String resetPasswordApi = "/auth/reset-password";

  // profile
  static String profileApi = "/profile";
  static String addFavoriteApi = "/favorites/add";
  static String deleteFavoriteApi = "/favorites/remove";
  static String isFavoriteApi = "/favorites/is-favorite";
  static String allFavoritesApi = "/favorites/all";

  // movies
  static String listMoviesApi = "/api/v2/list_movies.json";
  static String movieDetailsApi = "/api/v2/movie_details.json";
  static String movieSuggestionsApi = "/api/v2/movie_suggestions.json";
}
