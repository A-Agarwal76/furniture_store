import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class ApplicationTheme {
  const ApplicationTheme._();
  static const _primarySeedColor = Color(0xFFFFB800);
  static const _secondaryColor = Color(0xFF1A1A1A);

  static final TextTheme _baseTextTheme = GoogleFonts.poppinsTextTheme();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primarySeedColor,
      primary: _primarySeedColor,
      secondary: _secondaryColor,
    ),

    textTheme: _baseTextTheme.copyWith(
      displayLarge: _baseTextTheme.displayLarge?.copyWith(
        color: _secondaryColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: _baseTextTheme.titleLarge?.copyWith(
        color: _secondaryColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: _baseTextTheme.bodyLarge?.copyWith(
        color: _secondaryColor,
        fontSize: 16,
      ),
      bodyMedium: _baseTextTheme.bodyMedium?.copyWith(
        color: _secondaryColor,
        fontSize: 14,
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    scaffoldBackgroundColor: Colors.white,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primarySeedColor,
      primary: _primarySeedColor,
      secondary: _secondaryColor,
      brightness: Brightness.dark,
    ),

    textTheme: _baseTextTheme
        .copyWith(
          displayLarge: _baseTextTheme.displayLarge?.copyWith(
            color: const ColorScheme.dark().onSurface,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: _baseTextTheme.titleLarge?.copyWith(
            color: const ColorScheme.dark().onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: _baseTextTheme.bodyLarge?.copyWith(
            color: const ColorScheme.dark().onSurface,
            fontSize: 16,
          ),
          bodyMedium: _baseTextTheme.bodyMedium?.copyWith(
            color: const ColorScheme.dark().onSurface,
            fontSize: 14,
          ),
        )
        .apply(
          bodyColor: const ColorScheme.dark().onSurface,
          displayColor: const ColorScheme.dark().onSurface,
        ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
