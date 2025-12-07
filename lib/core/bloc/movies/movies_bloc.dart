import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/core/api/api_service.dart';
import 'package:movie/core/bloc/movies/movies_event.dart';
import 'package:movie/core/bloc/movies/movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final ApiService _apiService = ApiService();

  MoviesBloc() : super(MoviesInitial()) {
    on<LoadMoviesEvent>(_onLoadMovies);
    on<LoadMovieDetailsEvent>(_onLoadMovieDetails);
    on<LoadMovieSuggestionsEvent>(_onLoadMovieSuggestions);
  }

  Future<void> _onLoadMovies(
    LoadMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoading());
    try {
      final response = await _apiService.getMoviesList(
        limit: event.limit,
        page: event.page,
        quality: event.quality,
        minimumRating: event.minimumRating,
        queryTerm: event.queryTerm,
        genre: event.genre,
        sortBy: event.sortBy,
      );

      if (response.status == 'ok') {
        emit(MoviesLoaded(
          movies: response.data.movies,
          movieCount: response.data.movieCount,
          limit: response.data.limit,
          pageNumber: response.data.pageNumber,
        ));
      } else {
        emit(MoviesError(response.statusMessage));
      }
    } catch (e) {
      emit(MoviesError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadMovieDetails(
    LoadMovieDetailsEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MovieDetailsLoading());
    try {
      final response = await _apiService.getMovieDetails(event.movieId);

      if (response.status == 'ok') {
        emit(MovieDetailsLoaded(response.data.movie));
      } else {
        emit(MovieDetailsError(response.statusMessage));
      }
    } catch (e) {
      emit(MovieDetailsError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadMovieSuggestions(
    LoadMovieSuggestionsEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MovieSuggestionsLoading());
    try {
      final response = await _apiService.getMovieSuggestions(event.movieId);

      if (response.status == 'ok') {
        emit(MovieSuggestionsLoaded(response.data.movieSuggestions));
      } else {
        emit(MovieSuggestionsError(response.statusMessage));
      }
    } catch (e) {
      emit(MovieSuggestionsError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}

