import 'package:equatable/equatable.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object?> get props => [];
}

class LoadMoviesEvent extends MoviesEvent {
  final int? limit;
  final int? page;
  final String? quality;
  final double? minimumRating;
  final String? queryTerm;
  final String? genre;
  final String? sortBy;

  const LoadMoviesEvent({
    this.limit,
    this.page,
    this.quality,
    this.minimumRating,
    this.queryTerm,
    this.genre,
    this.sortBy,
  });

  @override
  List<Object?> get props => [
        limit,
        page,
        quality,
        minimumRating,
        queryTerm,
        genre,
        sortBy,
      ];
}

class LoadMovieDetailsEvent extends MoviesEvent {
  final int movieId;

  const LoadMovieDetailsEvent(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class LoadMovieSuggestionsEvent extends MoviesEvent {
  final int movieId;

  const LoadMovieSuggestionsEvent(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

