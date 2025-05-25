plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.music_social_app"
    compileSdk = flutter.compileSdkVersion

    // ────────────────────────────────────────────────────────────
    // Force the exact NDK revision required by flutter_secure_storage (and other plugins)
    // See build log: "flutter_secure_storage requires Android NDK 27.0.12077973"
    // ────────────────────────────────────────────────────────────
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Specify your own unique Application ID.
        applicationId = "com.example.music_social_app"

        // Minimum API level raised from 21 → 23 to satisfy plugin requirements (flutter_secure_storage 10.x).
        minSdk = 23

        // Keep the targetSdk in sync with Flutter's recommendation (usually 34).
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
