# TuneTalkr

TuneTalkr is a cross‑platform **Flutter** app that finally makes music social. Users can rate and discuss songs and albums—all in one place and without awkward links. 

## Key Features

* 🎧 **Discover new music** through personalised feeds and themed explore categories
* ⭐ **Rate songs & albums** (1–5 stars) and leave short reviews
* 📤 **Share music** and react to comments—directly inside the app
* 🤝 **Connect with like‑minded people**: follow friends
* 🔗 **Spotify sync** acces to your music

## Getting Started

### Prerequisites

| Tool                      | Recommended version   | Purpose                     |
| ------------------------- | --------------------- | --------------------------- |
| Flutter SDK               | ≥ 3.22 (incl. Dart 3) | App framework               |
| Android Studio / SDK      | ≥ 2024.1 (Hedgehog)   | Android build & emulator    |
| Xcode (macOS)             | ≥ 15                  | iOS build                   |
| Java                      | 17                    | Gradle build                |
| Spotify Developer account | —                     | OAuth keys for library sync |

> **Tip:** Run `flutter doctor` to verify your environment.

### Clone the repository

```bash
git clone https://github.com/TeomanEroglu/song-social-media-app.git
cd .\music_social_app\
```

### Install dependencies

```bash
flutter pub get
```

### Set up environment variables

Create a **.env** file in the project root use the .env.example as a template — it is loaded via [`flutter_dotenv`](https://pub.dev/packages/flutter_dotenv):

```
SPOTIFY_CLIENT_ID=<your_id>
SPOTIFY_REDIRECT_URI=tunetalkr://auth
```

(Add other keys such as `SPOTIFY_CLIENT_SECRET` in the same way.)

### Launch the app (hot reload)

```bash
flutter run
```

Flutter automatically picks a connected device or starts the configured emulator/simulator.

### Release builds

**Android** (APK / AAB):

```bash
flutter build apk --release
# or
flutter build appbundle --release
```

**iOS** (macOS only):

```bash
flutter build ios --release
```

Other platform targets (Web, macOS, Windows, Linux) can be tested with the respective Flutter beta channels.

## Project structure (short version)

```
├── lib/
│   ├── main.dart          # Application entry point & DI setup
│   ├── navigation/        # Custom bottom navigation system & bottom‑nav layout
│   ├── state/             # Global app state (Provider / Riverpod)
│   ├── services/          # API clients & persistence helpers
│   ├── data/              # Temporary sample data & domain models
│   ├── widgets/           # Reusable UI components
│   └── views/             # Feature‑oriented UI layers
│       ├── home/
│       ├── explore/
│       ├── library/
│       ├── login/
│       ├── messages/
│       ├── player/
│       └── profile/

```


