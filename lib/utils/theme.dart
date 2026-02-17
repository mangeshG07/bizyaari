import 'exported_path.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.grey.shade100,
    dividerColor: Colors.grey.shade300,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
    ),
    useMaterial3: false, // optional but safer for consistency
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black54),
      headlineSmall: TextStyle(color: Color(0xff9CA3AF)),
      bodySmall: TextStyle(color: Color(0xff111827)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xff262425),
    dividerColor: Colors.grey.shade700,
    useMaterial3: false, // optional but safer for consistency
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      bodySmall: TextStyle(color: Color(0xffFFFFFF)),
      headlineSmall: TextStyle(color: Color(0xff9CA3AF)),
    ),
  );
}
