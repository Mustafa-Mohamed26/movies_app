class FavoriteResponse {
  String? message;
  bool? status; // for is-favorite
  MovieData? movie; // for add/get one
  List<MovieData>? movies; // for get all

  FavoriteResponse({this.message, this.status, this.movie, this.movies});

  FavoriteResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];

    if (json['data'] is bool) {
      status = json['data'];
    } else if (json['data'] is Map<String, dynamic>) {
      movie = MovieData.fromJson(json['data']);
    } else if (json['data'] is List) {
      movies = (json['data'] as List)
          .map((item) => MovieData.fromJson(item))
          .toList();
    }
  }
}

class MovieData {
  String? movieId;
  String? name;
  double? rating;
  String? imageURL;
  String? year;

  MovieData({this.movieId, this.name, this.rating, this.imageURL, this.year});

  MovieData.fromJson(Map<String, dynamic> json) {
    movieId = json['movieId']?.toString();
    name = json['name']?.toString();
    rating = (json['rating'] is num) ? (json['rating'] as num).toDouble() : null;
    imageURL = json['imageURL']?.toString();
    year = json['year']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'movieId': movieId,
      'name': name,
      'rating': rating,
      'imageURL': imageURL,
      'year': year,
    };
  }
}
