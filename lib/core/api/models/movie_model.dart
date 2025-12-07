class MovieModel {
  final int id;
  final String title;
  final int year;
  final double rating;
  final List<String> genres;
  final String summary;
  final String? descriptionFull;
  final String mediumCoverImage;
  final String? largeCoverImage;
  final List<TorrentModel> torrents;

  MovieModel({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.genres,
    required this.summary,
    this.descriptionFull,
    required this.mediumCoverImage,
    this.largeCoverImage,
    required this.torrents,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      year: json['year'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      genres: List<String>.from(json['genres'] ?? []),
      summary: json['summary'] ?? '',
      descriptionFull: json['description_full'],
      mediumCoverImage: json['medium_cover_image'] ?? '',
      largeCoverImage: json['large_cover_image'],
      torrents: (json['torrents'] as List<dynamic>?)
              ?.map((torrent) => TorrentModel.fromJson(torrent))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'rating': rating,
      'genres': genres,
      'summary': summary,
      'description_full': descriptionFull,
      'medium_cover_image': mediumCoverImage,
      'large_cover_image': largeCoverImage,
      'torrents': torrents.map((torrent) => torrent.toJson()).toList(),
    };
  }
}

class TorrentModel {
  final String url;
  final String quality;
  final String size;
  final String? type;

  TorrentModel({
    required this.url,
    required this.quality,
    required this.size,
    this.type,
  });

  factory TorrentModel.fromJson(Map<String, dynamic> json) {
    return TorrentModel(
      url: json['url'] ?? '',
      quality: json['quality'] ?? '',
      size: json['size'] ?? '',
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'quality': quality,
      'size': size,
      'type': type,
    };
  }
}

class MoviesListResponse {
  final String status;
  final String statusMessage;
  final MoviesListData data;

  MoviesListResponse({
    required this.status,
    required this.statusMessage,
    required this.data,
  });

  factory MoviesListResponse.fromJson(Map<String, dynamic> json) {
    return MoviesListResponse(
      status: json['status'] ?? '',
      statusMessage: json['status_message'] ?? '',
      data: MoviesListData.fromJson(json['data'] ?? {}),
    );
  }
}

class MoviesListData {
  final int movieCount;
  final int limit;
  final int pageNumber;
  final List<MovieModel> movies;

  MoviesListData({
    required this.movieCount,
    required this.limit,
    required this.pageNumber,
    required this.movies,
  });

  factory MoviesListData.fromJson(Map<String, dynamic> json) {
    return MoviesListData(
      movieCount: json['movie_count'] ?? 0,
      limit: json['limit'] ?? 0,
      pageNumber: json['page_number'] ?? 0,
      movies: (json['movies'] as List<dynamic>?)
              ?.map((movie) => MovieModel.fromJson(movie))
              .toList() ??
          [],
    );
  }
}

class MovieDetailsResponse {
  final String status;
  final String statusMessage;
  final MovieDetailsData data;

  MovieDetailsResponse({
    required this.status,
    required this.statusMessage,
    required this.data,
  });

  factory MovieDetailsResponse.fromJson(Map<String, dynamic> json) {
    return MovieDetailsResponse(
      status: json['status'] ?? '',
      statusMessage: json['status_message'] ?? '',
      data: MovieDetailsData.fromJson(json['data'] ?? {}),
    );
  }
}

class MovieDetailsData {
  final MovieModel movie;

  MovieDetailsData({
    required this.movie,
  });

  factory MovieDetailsData.fromJson(Map<String, dynamic> json) {
    return MovieDetailsData(
      movie: MovieModel.fromJson(json['movie'] ?? {}),
    );
  }
}

class MovieSuggestionsResponse {
  final String status;
  final String statusMessage;
  final MovieSuggestionsData data;

  MovieSuggestionsResponse({
    required this.status,
    required this.statusMessage,
    required this.data,
  });

  factory MovieSuggestionsResponse.fromJson(Map<String, dynamic> json) {
    return MovieSuggestionsResponse(
      status: json['status'] ?? '',
      statusMessage: json['status_message'] ?? '',
      data: MovieSuggestionsData.fromJson(json['data'] ?? {}),
    );
  }
}

class MovieSuggestionsData {
  final List<MovieModel> movieSuggestions;

  MovieSuggestionsData({
    required this.movieSuggestions,
  });

  factory MovieSuggestionsData.fromJson(Map<String, dynamic> json) {
    return MovieSuggestionsData(
      movieSuggestions: (json['movie_suggestions'] as List<dynamic>?)
              ?.map((movie) => MovieModel.fromJson(movie))
              .toList() ??
          [],
    );
  }
}

