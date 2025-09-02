import 'dart:convert';

import 'package:movies_app/api/api_constants.dart';
import 'package:movies_app/api/end_points.dart';
import 'package:movies_app/models/list_of_movies_response.dart';
import 'package:movies_app/models/login_request.dart';
import 'package:movies_app/models/login_response.dart';
import 'package:movies_app/models/movie_details_response.dart';
import 'package:movies_app/models/movie_suggestions_response.dart';
import 'package:movies_app/models/update_request.dart';
import 'package:movies_app/models/update_response.dart';
import 'package:movies_app/models/user_request.dart';
import 'package:movies_app/models/user_response.dart';
import 'package:http/http.dart' as http;

class ApiManager {
  // Register Function
  static Future<UserResponse?> register(UserRequest userRequest) async {
    Uri url = Uri.https(ApiConstants.baseUrl, EndPoints.registerApi);
    try {
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json", // to be able to send json
        },
        body: jsonEncode(userRequest.toJson()), // to be able to send the user
      );
      var responseBody = response.body;
      var json = jsonDecode(responseBody);
      return UserResponse.fromJson(json);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<LoginResponse?> login(LoginRequest loginRequest) async {
    Uri url = Uri.https(ApiConstants.baseUrl, EndPoints.loginApi);
    try {
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json", // to be able to send json
        },
        body: jsonEncode(loginRequest.toJson()), // to be able to send the user
      );
      var responseBody = response.body;
      var json = jsonDecode(responseBody);
      return LoginResponse.fromJson(json);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<UserResponse?> getProfile({required String token}) async {
    Uri url = Uri.https(ApiConstants.baseUrl, EndPoints.profileApi);
    try {
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json", // to be able to send json
          "Authorization": "Bearer $token", // to be able to send the token
        },
      );
      var responseBody = response.body;
      var json = jsonDecode(responseBody);
      return UserResponse.fromJson(json);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<UpdateResponse?> updateProfile({
    required String token,
    required UpdateRequest updateRequest,
  }) async {
    Uri url = Uri.https(ApiConstants.baseUrl, EndPoints.profileApi);
    try {
      var response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json", // to be able to send json
          "Authorization": "Bearer $token", // to be able to send the token
        },
        body: jsonEncode(updateRequest.toJson()), // to be able to send the user
      );
      var responseBody = response.body;
      var json = jsonDecode(responseBody);
      return UpdateResponse.fromJson(json);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<UpdateResponse?> deleteProfile({required String token}) async {
    Uri url = Uri.https(ApiConstants.baseUrl, EndPoints.profileApi);
    try {
      var response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json", // to be able to send json
          "Authorization": "Bearer $token", // to be able to send the token
        },
      );
      var responseBody = response.body;
      var json = jsonDecode(responseBody);
      return UpdateResponse.fromJson(json);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<UpdateResponse?> resetPassword({
    required String token,
    required String oldPassword,
    required String newPassword,
  }) async {
    Uri url = Uri.https(ApiConstants.baseUrl, EndPoints.resetPasswordApi);

    try {
      var response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        }),
      );

      var responseBody = response.body;
      var json = jsonDecode(responseBody);
      return UpdateResponse.fromJson(json);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<ListOfMoviesResponse?> getListOfMovies({
    String? genre,
    int? limit,
    int? page,
    String? query,
  }) async {
    Uri url = Uri.https(ApiConstants.moviesBaseUrl, EndPoints.listMoviesApi, {
      "genre": genre,
      "limit": limit.toString(),
      "page": page.toString(),
      "query_term": query,
    });

    try {
      var response = await http.get(url);
      var responseBody = response.body;
      var json = jsonDecode(responseBody);
      return ListOfMoviesResponse.fromJson(json);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<MovieDetailsResponse?> getMovieDetails({
    required int? movieId,
    required bool withCast,
    required bool withImages,
  }) async {
    Uri url = Uri.https(ApiConstants.moviesBaseUrl, EndPoints.movieDetailsApi, {
      "movie_id": movieId.toString(),
      "with_cast": withCast ? "true" : "false",
      "with_images": withImages ? "true" : "false",
    });

    try {
      var response = await http.get(url);
      var responseBody = response.body;
      var json = jsonDecode(responseBody);
      return MovieDetailsResponse.fromJson(json);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<MovieSuggestionsResponse?> getMovieSuggestions({
    required int? movieId,
  }) async {
    Uri url = Uri.https(
      ApiConstants.moviesBaseUrl,
      EndPoints.movieSuggestionsApi,
      {"movie_id": movieId.toString()},
    );

    try {
      var response = await http.get(url);
      var responseBody = response.body;
      var json = jsonDecode(responseBody);
      return MovieSuggestionsResponse.fromJson(json);
    } catch (e) {
      throw Exception(e);
    }
  }
}
