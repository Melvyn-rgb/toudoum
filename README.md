# IPTV Player

An advanced IPTV Player built with Flutter, designed for seamless streaming and playback of IPTV channels. This project supports `.m3u8` files and HLS streams with customizable features and a user-friendly interface.

## Features

- **HLS Streaming**: Supports `.m3u8` playlists for high-quality video playback.
- **EPG Integration**: Displays program guides and schedule (optional).
- **Custom Playlists**: Add and manage user-defined playlists.
- **Search Functionality**: Quickly find channels by name or category.
- **Multi-Platform**: Works on Android, iOS, and web.
- **Advanced Player Controls**:
    - Play, pause, and seek.
    - Volume and brightness controls.
    - Support for subtitles and multi-audio tracks.
- **Error Handling**: Displays errors when streams are unavailable or playlists are malformed.

## Installation

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart: Ensure it is included with the Flutter SDK.
- IDE: VS Code, Android Studio, or any preferred Flutter-supported IDE.

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/iptv-player.git
   cd iptv-player
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Usage

1. Launch the app on your preferred platform (Android, iOS, or web).
2. Add a playlist by uploading an `.m3u8` file or pasting a URL.
3. Select a channel from the playlist to start streaming.
4. Use the player controls for playback customization.

## Screenshots

| Home Screen | Playlist Screen | Player Screen |
|-------------|-----------------|---------------|
| ![Home](screenshots/home.png) | ![Playlist](screenshots/playlist.png) | ![Player](screenshots/player.png) |

## Project Structure

```
lib/
|-- main.dart            # Entry point of the app
|-- screens/             # UI screens
|   |-- home_screen.dart
|   |-- player_screen.dart
|   |-- playlist_screen.dart
|-- widgets/             # Reusable UI components
|-- services/            # Business logic and backend services
|   |-- playlist_service.dart
|   |-- hls_service.dart
|-- utils/               # Utility functions
pubspec.yaml              # Project dependencies
```

## Dependencies

- **Flutter SDK**: Core framework
- **video_player**: For video playback
- **flutter_hls_player**: To handle HLS streams
- **provider**: State management
- **http**: Fetching playlist data from APIs
- **shared_preferences**: Storing user settings and playlists

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature-name
   ```
3. Make your changes and commit them:
   ```bash
   git commit -m "Add feature name"
   ```
4. Push to the branch:
   ```bash
   git push origin feature-name
   ```
5. Open a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For questions or support, please contact:
- Email: your.email@example.com
- GitHub: [your-username](https://github.com/your-username)
