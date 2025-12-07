# Movies App

A Flutter application for browsing and discovering movies using the YTS API.

## Features

- **Home Tab**: Browse featured movies with carousel and horizontal scrolling
- **Movie Details**: View detailed information about movies including description, genres, and download options
- **Movie Suggestions**: Get personalized movie recommendations
- **Responsive Design**: Works seamlessly across mobile, tablet, and desktop
- **State Management**: Built with Bloc pattern for clean architecture

## Tech Stack

- Flutter
- Bloc State Management
- YTS API Integration
- Responsive Design Utilities

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone https://github.com/abdallahsultan74/movies_app.git
cd movies_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── api/
│   │   ├── api_constants.dart
│   │   ├── api_service.dart
│   │   └── models/
│   ├── bloc/
│   │   └── movies/
│   ├── theme/
│   └── utils/
│       └── responsive.dart
├── screens/
│   ├── auth/
│   ├── home/
│   │   ├── home_tab.dart
│   │   └── movie_details_screen.dart
│   ├── onboarding/
│   └── splash/
└── main.dart
```

## API Integration

The app uses the YTS API for movie data:
- List Movies: `https://yts.lt/api/v2/list_movies.json`
- Movie Details: `https://yts.lt/api/v2/movie_details.json`
- Movie Suggestions: `https://yts.lt/api/v2/movie_suggestions.json`

## State Management

The app uses the Bloc pattern for state management:
- `MoviesBloc`: Handles movie list, details, and suggestions
- Events: `LoadMoviesEvent`, `LoadMovieDetailsEvent`, `LoadMovieSuggestionsEvent`
- States: `MoviesLoading`, `MoviesLoaded`, `MoviesError`, etc.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.
