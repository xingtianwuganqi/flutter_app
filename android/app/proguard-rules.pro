-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keepclasseswithmembers class * {
    @retrofit2.http.* <methods>;
}

-keep public class com.anythink.flutter.**
-keepclassmembers class com.anythink.flutter.** {
   public *;
}

-ignorewarnings