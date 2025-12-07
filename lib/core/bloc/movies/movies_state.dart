import 'package:equatable/equatable.dart';
import 'package:movie/core/api/models/movie_model.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object?> get props => [];
}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<MovieModel> movies;
  final int movieCount;
  final int limit;
  final int pageNumber;

  const MoviesLoaded({
    required this.movies,
    required this.movieCount,
    required this.limit,
    required this.pageNumber,
  });

  @override
  List<Object?> get props => [movies, movieCount, limit, pageNumber];
}

class MoviesError extends MoviesState {
  final String message;

  const MoviesError(this.message);

  @override
  List<Object?> get props => [message];
}

// Movie Details States
class MovieDetailsInitial extends MoviesState {}

class MovieDetailsLoading extends MoviesState {}

class MovieDetailsLoaded extends MoviesState {
  final MovieModel movie;

  const MovieDetailsLoaded(this.movie);

  @override
  List<Object?> get props => [movie];
}

class MovieDetailsError extends MoviesState {
  final String message;

  const MovieDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Movie Suggestions States
class MovieSuggestionsInitial extends MoviesState {}

class MovieSuggestionsLoading extends MoviesState {}

class MovieSuggestionsLoaded extends MoviesState {
  final List<MovieModel> suggestions;

  const MovieSuggestionsLoaded(this.suggestions);

  @override
  List<Object?> get props => [suggestions];
}

class MovieSuggestionsError extends MoviesState {
  final String message;

  const MovieSuggestionsError(this.message);

  @override
  List<Object?> get props => [message];
}

