plugins {

    id("com.android.application")

    id("kotlin-android")

    // =========================
    // Firebase Google Services
    // =========================
    id("com.google.gms.google-services")

    // =========================
    // Flutter
    // =========================
    id("dev.flutter.flutter-gradle-plugin")
}

android {

    namespace = "com.keiba_ai_yosou"

    compileSdk = flutter.compileSdkVersion

    ndkVersion = flutter.ndkVersion


    // =========================
    // Java Version
    // =========================
    compileOptions {

        sourceCompatibility =
            JavaVersion.VERSION_17

        targetCompatibility =
            JavaVersion.VERSION_17

        // =========================
        // 🔥 flutter_local_notifications対応
        // =========================
        isCoreLibraryDesugaringEnabled =
            true
    }

    kotlinOptions {

        jvmTarget =
            JavaVersion.VERSION_17.toString()
    }


    // =========================
    // Default Config
    // =========================
    defaultConfig {

        applicationId =
            "com.keiba_ai_yosou"

        minSdk =
            flutter.minSdkVersion

        targetSdk =
            flutter.targetSdkVersion

        versionCode =
            flutter.versionCode

        versionName =
            flutter.versionName
    }


    // =========================
    // Release
    // =========================
    buildTypes {

        release {

            signingConfig =
                signingConfigs.getByName("debug")
        }
    }
}


// =========================
// Firebase Dependencies
// =========================
dependencies {

    // =========================
    // 🔥 Desugaring（超重要）
    // =========================
    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.1.4"
    )

    // Firebase BoM
    implementation(
        platform(
            "com.google.firebase:firebase-bom:34.13.0"
        )
    )

    // Firebase Analytics
    implementation(
        "com.google.firebase:firebase-analytics"
    )
}


// =========================
// Flutter
// =========================
flutter {

    source = "../.."
}