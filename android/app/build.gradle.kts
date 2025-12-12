import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    // id("com.google.gms.google-services") // Uncomment when using Firebase
    // id("com.google.firebase.crashlytics")
}

// Load local.properties
val localProperties = Properties().apply {
    val localPropsFile = rootProject.file("local.properties")
    if (localPropsFile.exists()) {
        FileInputStream(localPropsFile).use { load(it) }
    }
}

// Load environment variables from .env
val env: Properties = Properties().apply {
    val envFile = File(rootProject.projectDir.parentFile, ".env")
    if (envFile.exists()) {
        FileInputStream(envFile).use { load(it) }
    } else {
        throw IllegalStateException("Environment file .env not found.")
    }
}

android {
    namespace = "com.example.startup_repo"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    sourceSets["main"].java.srcDirs("src/main/kotlin")

    defaultConfig {
        applicationId = env.getProperty("BUNDLE_ID_ANDROID")
        minSdk = env.getProperty("MIN_SDK_VERSION")?.toInt() ?: 21
        targetSdk = env.getProperty("TARGET_SDK_VERSION")?.toInt() ?: 34
        versionCode = env.getProperty("ANDROID_VERSION_CODE")?.toInt() ?: 1
        versionName = env.getProperty("ANDROID_VERSION_NAME") ?: "1.0"
        multiDexEnabled = true

        resValue("string", "app_name", env.getProperty("APP_NAME") ?: "Flutter Anadconda")
    }

    signingConfigs {
        val keystorePath = env.getProperty("KEYSTORE_PATH")
        if (keystorePath != null && file(keystorePath).exists()) {
            create("release") {
                storeFile = file(keystorePath)
                storePassword = env.getProperty("KEYSTORE_PASSWORD")
                keyAlias = env.getProperty("KEYSTORE_ALIAS")
                keyPassword = env.getProperty("KEY_PASSWORD")
            }
        }
    }

    buildTypes {
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }
        getByName("release") {
            val releaseSigningConfig = signingConfigs.findByName("release")
            if (releaseSigningConfig != null) {
                signingConfig = releaseSigningConfig
            }
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
