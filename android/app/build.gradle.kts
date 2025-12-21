plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}


android {
    namespace = "com.example.dribbl_id"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.dribbl_id"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
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

// Safe APK renamer: runs after assembleRelease and renames generated APK files
tasks.register("renameApks") {
    doLast {
        val outDir = file("build/app/outputs/flutter-apk")
        if (outDir.exists()) {
            outDir.listFiles()?.filter { it.extension == "apk" }?.forEach { f ->
                val versionName = android.defaultConfig.versionName ?: project.version.toString()
                val buildType = "release"
                val safeAppName = "dribbl_id"
                val newName = "$safeAppName-$buildType-$versionName-${f.name}"
                val dest = File(outDir, newName)
                if (!f.renameTo(dest)) {
                    logger.warn("Failed to rename ${f.name} -> $newName")
                } else {
                    logger.lifecycle("Renamed ${f.name} -> $newName")
                }
            }
        }
    }
}

// Some AGP/Flutter plugin task names may not be present at configuration time.
// Use matching/configureEach so we don't fail if the task is added later.
tasks.matching { it.name == "assembleRelease" }.configureEach {
    finalizedBy("renameApks")
}
