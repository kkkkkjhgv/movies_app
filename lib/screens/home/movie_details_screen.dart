import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/core/api/models/movie_model.dart';
import 'package:movie/core/bloc/movies/movies_bloc.dart';
import 'package:movie/core/bloc/movies/movies_event.dart';
import 'package:movie/core/bloc/movies/movies_state.dart';
import 'package:movie/core/theme/app_colors.dart';
import 'package:movie/core/utils/responsive.dart';

class MovieDetailsScreen extends StatefulWidget {
  static const routeName = '/movie_details';

  const MovieDetailsScreen({super.key});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  int? _lastLoadedMovieId;
  MovieModel? _cachedMovie;

  void _loadMovieDetails(int movieId) {
    if (_lastLoadedMovieId == movieId && _cachedMovie != null) {
      return;
    }
    
    _lastLoadedMovieId = movieId;
    _cachedMovie = null;
    context.read<MoviesBloc>().add(LoadMovieDetailsEvent(movieId));
    context.read<MoviesBloc>().add(LoadMovieSuggestionsEvent(movieId));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final movieId = ModalRoute.of(context)?.settings.arguments as int?;
        if (movieId != null) {
          _loadMovieDetails(movieId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieId = ModalRoute.of(context)!.settings.arguments as int;

    if (movieId != _lastLoadedMovieId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && movieId != _lastLoadedMovieId) {
          _loadMovieDetails(movieId);
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.Black,
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is MovieDetailsLoading) {
            if (_cachedMovie != null && _cachedMovie!.id == movieId) {
              return _buildMovieDetailsContent(context, _cachedMovie!);
            }
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.yellow,
              ),
            );
          }

          if (state is MovieDetailsError) {
            if (_cachedMovie != null && _cachedMovie!.id == movieId) {
              return _buildMovieDetailsContent(context, _cachedMovie!);
            }
            
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.white.withOpacity(0.5),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      state.message,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        _lastLoadedMovieId = null;
                        _cachedMovie = null;
                        _loadMovieDetails(movieId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          color: AppColors.Black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is MovieDetailsLoaded) {
            if (state.movie.id == movieId) {
              _cachedMovie = state.movie;
              return _buildMovieDetailsContent(context, state.movie);
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _lastLoadedMovieId = null;
                  _cachedMovie = null;
                  _loadMovieDetails(movieId);
                }
              });
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.yellow,
                ),
              );
            }
          }

          if (state is MovieSuggestionsLoading || 
              state is MovieSuggestionsLoaded ||
              state is MovieSuggestionsError) {
            if (_cachedMovie != null && _cachedMovie!.id == movieId) {
              return _buildMovieDetailsContent(context, _cachedMovie!);
            }
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.yellow,
              ),
            );
          }

          if (_cachedMovie != null && _cachedMovie!.id == movieId) {
            return _buildMovieDetailsContent(context, _cachedMovie!);
          }
          
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.yellow,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieDetailsContent(BuildContext context, MovieModel movie) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, movie),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(
              Responsive.getResponsiveValue(
                context,
                mobile: 16.0,
                tablet: 24.0,
                desktop: 32.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMovieInfo(context, movie),
                const SizedBox(height: 24),
                _buildMovieDescription(context, movie),
                const SizedBox(height: 24),
                _buildGenres(context, movie),
                const SizedBox(height: 24),
                _buildTorrents(context, movie),
                const SizedBox(height: 24),
                _buildSuggestions(context, movie.id),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, MovieModel movie) {
    final imageHeight = Responsive.getResponsiveValue(
      context,
      mobile: 300.0,
      tablet: 400.0,
      desktop: 500.0,
    );

    return SliverAppBar(
      expandedHeight: imageHeight,
      pinned: true,
      backgroundColor: AppColors.Black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            movie.largeCoverImage?.isNotEmpty == true
                ? Image.network(
                    movie.largeCoverImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.grey,
                        child: const Center(
                          child: Icon(
                            Icons.movie,
                            color: AppColors.white,
                            size: 64,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: AppColors.yellow,
                        ),
                      );
                    },
                  )
                : Container(
                    color: AppColors.grey,
                    child: const Center(
                      child: Icon(
                        Icons.movie,
                        color: AppColors.white,
                        size: 64,
                      ),
                    ),
                  ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.Black.withOpacity(0.7),
                    AppColors.Black,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieInfo(BuildContext context, MovieModel movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie.title,
          style: TextStyle(
            color: AppColors.white,
            fontSize: Responsive.getResponsiveFontSize(
              context,
              mobile: 24.0,
              tablet: 28.0,
              desktop: 32.0,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              '${movie.year}',
              style: TextStyle(
                color: AppColors.white.withOpacity(0.7),
                fontSize: Responsive.getResponsiveFontSize(
                  context,
                  mobile: 16.0,
                  tablet: 18.0,
                  desktop: 20.0,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: AppColors.yellow,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  movie.rating.toStringAsFixed(1),
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: Responsive.getResponsiveFontSize(
                      context,
                      mobile: 16.0,
                      tablet: 18.0,
                      desktop: 20.0,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMovieDescription(BuildContext context, MovieModel movie) {
    final description = movie.descriptionFull ?? movie.summary;
    
    if (description.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Story',
          style: TextStyle(
            color: AppColors.white,
            fontSize: Responsive.getResponsiveFontSize(
              context,
              mobile: 20.0,
              tablet: 22.0,
              desktop: 24.0,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: TextStyle(
            color: AppColors.white.withOpacity(0.8),
            fontSize: Responsive.getResponsiveFontSize(
              context,
              mobile: 14.0,
              tablet: 16.0,
              desktop: 18.0,
            ),
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildGenres(BuildContext context, MovieModel movie) {
    if (movie.genres.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Genres',
          style: TextStyle(
            color: AppColors.white,
            fontSize: Responsive.getResponsiveFontSize(
              context,
              mobile: 20.0,
              tablet: 22.0,
              desktop: 24.0,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: movie.genres.map((genre) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.yellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.yellow, width: 1),
              ),
              child: Text(
                genre,
                style: TextStyle(
                  color: AppColors.yellow,
                  fontSize: Responsive.getResponsiveFontSize(
                    context,
                    mobile: 12.0,
                    tablet: 14.0,
                    desktop: 16.0,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTorrents(BuildContext context, MovieModel movie) {
    if (movie.torrents.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Download Options',
          style: TextStyle(
            color: AppColors.white,
            fontSize: Responsive.getResponsiveFontSize(
              context,
              mobile: 20.0,
              tablet: 22.0,
              desktop: 24.0,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...movie.torrents.map((torrent) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      torrent.quality,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: Responsive.getResponsiveFontSize(
                          context,
                          mobile: 14.0,
                          tablet: 16.0,
                          desktop: 18.0,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      torrent.size,
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.7),
                        fontSize: Responsive.getResponsiveFontSize(
                          context,
                          mobile: 12.0,
                          tablet: 14.0,
                          desktop: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.download,
                    color: AppColors.yellow,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSuggestions(BuildContext context, int movieId) {
    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: (context, state) {
        if (state is MovieSuggestionsLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.yellow,
            ),
          );
        }

        if (state is MovieSuggestionsError) {
          return const SizedBox.shrink();
        }

        if (state is MovieSuggestionsLoaded) {
          final suggestions = state.suggestions;
          
          if (suggestions.isEmpty) {
            return const SizedBox.shrink();
          }

          final cardWidth = Responsive.getResponsiveValue(
            context,
            mobile: 120.0,
            tablet: 150.0,
            desktop: 180.0,
          );
          
          final cardHeight = Responsive.getResponsiveValue(
            context,
            mobile: 180.0,
            tablet: 225.0,
            desktop: 270.0,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Suggested Movies',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: Responsive.getResponsiveFontSize(
                    context,
                    mobile: 20.0,
                    tablet: 22.0,
                    desktop: 24.0,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: cardHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: suggestions.length > 10 ? 10 : suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = suggestions[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          MovieDetailsScreen.routeName,
                          arguments: suggestion.id,
                        );
                      },
                      child: Container(
                        width: cardWidth,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: suggestion.mediumCoverImage.isNotEmpty
                                      ? Image.network(
                                          suggestion.mediumCoverImage,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: AppColors.grey,
                                              child: const Center(
                                                child: Icon(
                                                  Icons.movie,
                                                  color: AppColors.white,
                                                  size: 32,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          color: AppColors.grey,
                                          child: const Center(
                                            child: Icon(
                                              Icons.movie,
                                              color: AppColors.white,
                                              size: 32,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              suggestion.title,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: Responsive.getResponsiveFontSize(
                                  context,
                                  mobile: 12.0,
                                  tablet: 14.0,
                                  desktop: 16.0,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

