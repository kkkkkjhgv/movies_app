import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie/core/api/api_constants.dart';
import 'package:movie/core/api/models/register_request.dart';
import 'package:movie/core/api/models/register_response.dart';
import 'package:movie/core/api/models/login_request.dart';
import 'package:movie/core/api/models/login_response.dart';
import 'package:movie/core/api/models/reset_password_request.dart';
import 'package:movie/core/api/models/reset_password_response.dart';
import 'package:movie/core/api/models/update_profile_request.dart';
import 'package:movie/core/api/models/update_profile_response.dart';
import 'package:movie/core/api/models/get_profile_response.dart';
import 'package:movie/core/api/models/delete_profile_response.dart';
import 'package:movie/core/api/models/movie_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String get baseUrl => ApiConstants.baseUrl;

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final url = Uri.parse('$baseUrl${ApiConstants.register}');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponse.fromJson(responseData);
      } else {
        throw Exception(
          responseData['message'] ?? 'Registration failed. Please try again.',
        );
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Data format error. Please try again.');
      } else if (e.toString().contains('SocketException') || 
                 e.toString().contains('Failed host lookup') ||
                 e.toString().contains('No address associated')) {
        throw Exception('Cannot connect to server. Please check your internet connection.');
      } else if (e is Exception) {
        final errorMessage = e.toString();
        if (errorMessage.contains('Exception: ')) {
          rethrow;
        }
        throw Exception('Error: ${errorMessage.replaceAll('Exception: ', '')}');
      }
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final url = Uri.parse('$baseUrl${ApiConstants.login}');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData.containsKey('token') && responseData['token'] != null) {
          if (responseData['data'] != null && responseData['data'] is Map) {
            (responseData['data'] as Map<String, dynamic>)['token'] = responseData['token'];
          }
        }
        
        return LoginResponse.fromJson(responseData);
      } else {
        throw Exception(
          responseData['message'] ?? 'Login failed. Please try again.',
        );
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Data format error. Please try again.');
      } else if (e.toString().contains('SocketException') || 
                 e.toString().contains('Failed host lookup') ||
                 e.toString().contains('No address associated')) {
        throw Exception('Cannot connect to server. Please check your internet connection.');
      } else if (e is Exception) {
        final errorMessage = e.toString();
        if (errorMessage.contains('Exception: ')) {
          rethrow;
        }
        throw Exception('Error: ${errorMessage.replaceAll('Exception: ', '')}');
      }
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<ResetPasswordResponse> resetPassword(
    ResetPasswordRequest request,
    String token,
  ) async {
    try {
      final url = Uri.parse('$baseUrl${ApiConstants.resetPassword}');
      
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResetPasswordResponse.fromJson(responseData);
      } else {
        throw Exception(
          responseData['message'] ?? 'Password reset failed. Please try again.',
        );
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Data format error. Please try again.');
      } else if (e.toString().contains('SocketException') || 
                 e.toString().contains('Failed host lookup') ||
                 e.toString().contains('No address associated')) {
        throw Exception('Cannot connect to server. Please check your internet connection.');
      } else if (e is Exception) {
        final errorMessage = e.toString();
        if (errorMessage.contains('Exception: ')) {
          rethrow;
        }
        throw Exception('Error: ${errorMessage.replaceAll('Exception: ', '')}');
      }
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<GetProfileResponse> getProfile(String token) async {
    try {
      final url = Uri.parse('$baseUrl${ApiConstants.profile}');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return GetProfileResponse.fromJson(responseData);
      } else {
        throw Exception(
          responseData['message'] ?? 'Failed to get profile data. Please try again.',
        );
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Data format error. Please try again.');
      } else if (e.toString().contains('SocketException') || 
                 e.toString().contains('Failed host lookup') ||
                 e.toString().contains('No address associated')) {
        throw Exception('Cannot connect to server. Please check your internet connection.');
      } else if (e is Exception) {
        final errorMessage = e.toString();
        if (errorMessage.contains('Exception: ')) {
          rethrow;
        }
        throw Exception('Error: ${errorMessage.replaceAll('Exception: ', '')}');
      }
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<UpdateProfileResponse> updateProfile(
    UpdateProfileRequest request,
    String token,
  ) async {
    try {
      final url = Uri.parse('$baseUrl${ApiConstants.updateProfile}');
      
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UpdateProfileResponse.fromJson(responseData);
      } else {
        throw Exception(
          responseData['message'] ?? 'Failed to update profile. Please try again.',
        );
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Data format error. Please try again.');
      } else if (e.toString().contains('SocketException') || 
                 e.toString().contains('Failed host lookup') ||
                 e.toString().contains('No address associated')) {
        throw Exception('Cannot connect to server. Please check your internet connection.');
      } else if (e is Exception) {
        final errorMessage = e.toString();
        if (errorMessage.contains('Exception: ')) {
          rethrow;
        }
        throw Exception('Error: ${errorMessage.replaceAll('Exception: ', '')}');
      }
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<DeleteProfileResponse> deleteProfile(String token) async {
    try {
      final url = Uri.parse('$baseUrl${ApiConstants.deleteProfile}');
      
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DeleteProfileResponse.fromJson(responseData);
      } else {
        throw Exception(
          responseData['message'] ?? 'Failed to delete account. Please try again.',
        );
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Data format error. Please try again.');
      } else if (e.toString().contains('SocketException') || 
                 e.toString().contains('Failed host lookup') ||
                 e.toString().contains('No address associated')) {
        throw Exception('Cannot connect to server. Please check your internet connection.');
      } else if (e is Exception) {
        final errorMessage = e.toString();
        if (errorMessage.contains('Exception: ')) {
          rethrow;
        }
        throw Exception('Error: ${errorMessage.replaceAll('Exception: ', '')}');
      }
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<MoviesListResponse> getMoviesList({
    int? limit,
    int? page,
    String? quality,
    double? minimumRating,
    String? queryTerm,
    String? genre,
    String? sortBy,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.ytsBaseUrl}${ApiConstants.listMovies}');
      final queryParams = <String, String>{};
      
      if (limit != null) queryParams['limit'] = limit.toString();
      if (page != null) queryParams['page'] = page.toString();
      if (quality != null) queryParams['quality'] = quality;
      if (minimumRating != null) queryParams['minimum_rating'] = minimumRating.toString();
      if (queryTerm != null) queryParams['query_term'] = queryTerm;
      if (genre != null) queryParams['genre'] = genre;
      if (sortBy != null) queryParams['sort_by'] = sortBy;

      final url = uri.replace(queryParameters: queryParams);
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Check if status is 'ok' in response
        if (responseData['status'] == 'ok') {
          return MoviesListResponse.fromJson(responseData);
        } else {
          throw Exception(
            responseData['status_message'] ?? 'Failed to fetch movies. Please try again.',
          );
        }
      } else {
        throw Exception(
          responseData['status_message'] ?? 'Failed to fetch movies. Please try again.',
        );
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Data format error. Please try again.');
      } else if (e.toString().contains('SocketException') || 
                 e.toString().contains('Failed host lookup') ||
                 e.toString().contains('No address associated')) {
        throw Exception('Cannot connect to server. Please check your internet connection.');
      } else if (e is Exception) {
        final errorMessage = e.toString();
        if (errorMessage.contains('Exception: ')) {
          rethrow;
        }
        throw Exception('Error: ${errorMessage.replaceAll('Exception: ', '')}');
      }
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<MovieDetailsResponse> getMovieDetails(int movieId) async {
    try {
      final url = Uri.parse('${ApiConstants.ytsBaseUrl}${ApiConstants.movieDetails}?movie_id=$movieId');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Check if status is 'ok' in response
        if (responseData['status'] == 'ok') {
          return MovieDetailsResponse.fromJson(responseData);
        } else {
          throw Exception(
            responseData['status_message'] ?? 'Failed to fetch movie details. Please try again.',
          );
        }
      } else {
        throw Exception(
          responseData['status_message'] ?? 'Failed to fetch movie details. Please try again.',
        );
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Data format error. Please try again.');
      } else if (e.toString().contains('SocketException') || 
                 e.toString().contains('Failed host lookup') ||
                 e.toString().contains('No address associated')) {
        throw Exception('Cannot connect to server. Please check your internet connection.');
      } else if (e is Exception) {
        final errorMessage = e.toString();
        if (errorMessage.contains('Exception: ')) {
          rethrow;
        }
        throw Exception('Error: ${errorMessage.replaceAll('Exception: ', '')}');
      }
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<MovieSuggestionsResponse> getMovieSuggestions(int movieId) async {
    try {
      final url = Uri.parse('${ApiConstants.ytsBaseUrl}${ApiConstants.movieSuggestions}?movie_id=$movieId');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Check if status is 'ok' in response
        if (responseData['status'] == 'ok') {
          return MovieSuggestionsResponse.fromJson(responseData);
        } else {
          throw Exception(
            responseData['status_message'] ?? 'Failed to fetch movie suggestions. Please try again.',
          );
        }
      } else {
        throw Exception(
          responseData['status_message'] ?? 'Failed to fetch movie suggestions. Please try again.',
        );
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Data format error. Please try again.');
      } else if (e.toString().contains('SocketException') || 
                 e.toString().contains('Failed host lookup') ||
                 e.toString().contains('No address associated')) {
        throw Exception('Cannot connect to server. Please check your internet connection.');
      } else if (e is Exception) {
        final errorMessage = e.toString();
        if (errorMessage.contains('Exception: ')) {
          rethrow;
        }
        throw Exception('Error: ${errorMessage.replaceAll('Exception: ', '')}');
      }
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }
}

