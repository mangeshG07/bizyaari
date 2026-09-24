# Flutter Engine & Plugin Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# Keep all FlutterPlugin implementations & Method Channels
-keep class * implements io.flutter.embedding.engine.plugins.FlutterPlugin { *; }
-keep class * implements io.flutter.plugin.common.PluginRegistry$PluginRegistrantCallback { *; }
-keep class * implements io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }

# Pigeon & Platform Channels (Shared Preferences & Path Provider Fix)
-keep class dev.flutter.pigeon.** { *; }
-keep interface dev.flutter.pigeon.** { *; }
-keepclassmembers class dev.flutter.pigeon.** { *; }
-keep class **.Messages$* { *; }
-keep class dev.flutter.pigeon.shared_preferences_android.** { *; }
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Firebase & Google Play Services
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Flutter Local Notifications & Gson
-keep class com.dexterous.** { *; }
-dontwarn com.dexterous.**
-keep class androidx.lifecycle.DefaultLifecycleObserver
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**
-keepclassmembers,allowobfuscation class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Flutter InAppWebView
-keep class com.pichillilorenzo.flutter_inappwebview_android.** { *; }
-dontwarn com.pichillilorenzo.flutter_inappwebview_android.**
-dontwarn com.ryanharter.auto.value.gson.GsonTypeAdapterFactory

# Image Cropper / UCrop
-keep class com.yalantis.ucrop** { *; }
-dontwarn com.yalantis.ucrop**

# Other Plugins
-keep class com.baseflow.geolocator.** { *; }
-keep class com.baseflow.geocoding.** { *; }
-keep class com.lyokone.location.** { *; }
-keep class dev.fluttercommunity.plus.connectivity.** { *; }