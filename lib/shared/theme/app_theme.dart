import 'package:flutter/material.dart';

class AppTheme {
  static const ink = Color(0xFF172026);
  static const muted = Color(0xFF6C7780);
  static const line = Color(0xFFE6EAED);
  static const canvas = Color(0xFFF5F8F9);
  static const surface = Colors.white;
  static const surfaceSoft = Color(0xFFEEF4F5);
  static const cyan = Color(0xFF20B8D6);
  static const mint = Color(0xFF31C48D);
  static const coral = Color(0xFFFF4D5E);
  static const amber = Color(0xFFFFB020);
  static const violet = Color(0xFF7C5CFF);
  static const darkInk = Color(0xFFF4F7F8);
  static const darkMuted = Color(0xFFAAB7BE);
  static const darkLine = Color(0xFF2A3941);
  static const darkCanvas = Color(0xFF0C1418);
  static const darkSurface = Color(0xFF121E24);
  static const darkSurfaceSoft = Color(0xFF18262D);

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color text(BuildContext context) => isDark(context) ? darkInk : ink;

  static Color mutedText(BuildContext context) =>
      isDark(context) ? darkMuted : muted;

  static Color border(BuildContext context) =>
      isDark(context) ? darkLine : line;

  static Color card(BuildContext context) =>
      isDark(context) ? darkSurface : surface;

  static Color softSurface(BuildContext context) =>
      isDark(context) ? darkSurfaceSoft : surfaceSoft;

  static Color page(BuildContext context) =>
      isDark(context) ? darkCanvas : canvas;

  static Color inverse(BuildContext context) => isDark(context) ? darkInk : ink;

  static Color onInverse(BuildContext context) =>
      isDark(context) ? darkCanvas : Colors.white;

  static Color subtleTint(
    BuildContext context,
    Color color, [
    double alpha = 0.12,
  ]) {
    final dark = isDark(context);
    return color.withValues(alpha: dark ? alpha + 0.04 : alpha);
  }

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: cyan,
      brightness: Brightness.light,
      primary: cyan,
      secondary: coral,
      surface: surface,
      error: coral,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: canvas,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displaySmall: TextStyle(fontWeight: FontWeight.w900, color: ink),
        headlineSmall: TextStyle(fontWeight: FontWeight.w900, color: ink),
        titleLarge: TextStyle(fontWeight: FontWeight.w900, color: ink),
        titleMedium: TextStyle(fontWeight: FontWeight.w800, color: ink),
        bodyMedium: TextStyle(color: ink),
        bodySmall: TextStyle(color: muted, fontWeight: FontWeight.w600),
        labelLarge: TextStyle(fontWeight: FontWeight.w800),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: cyan.withValues(alpha: 0.14),
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected) ? ink : muted,
            fontWeight:
                states.contains(WidgetState.selected)
                    ? FontWeight.w900
                    : FontWeight.w700,
            fontSize: 12,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? ink : muted,
            size: 24,
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: line),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ink,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          minimumSize: const Size(48, 48),
          side: const BorderSide(color: line),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cyan,
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        labelStyle: const TextStyle(color: muted, fontWeight: FontWeight.w700),
        hintStyle: const TextStyle(color: muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: cyan, width: 1.4),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected) ? ink : muted,
          ),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected)
                    ? cyan.withValues(alpha: 0.12)
                    : surface,
          ),
          side: WidgetStateProperty.all(const BorderSide(color: line)),
          textStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceSoft,
        selectedColor: cyan.withValues(alpha: 0.14),
        disabledColor: line,
        side: const BorderSide(color: line),
        labelStyle: const TextStyle(color: ink, fontWeight: FontWeight.w800),
        secondaryLabelStyle: const TextStyle(
          color: ink,
          fontWeight: FontWeight.w800,
        ),
        iconTheme: const IconThemeData(color: cyan),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ink,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: const DividerThemeData(color: line, thickness: 1),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: cyan,
      brightness: Brightness.dark,
      primary: cyan,
      secondary: coral,
      surface: darkSurface,
      error: coral,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: darkCanvas,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displaySmall: TextStyle(fontWeight: FontWeight.w900, color: darkInk),
        headlineSmall: TextStyle(fontWeight: FontWeight.w900, color: darkInk),
        titleLarge: TextStyle(fontWeight: FontWeight.w900, color: darkInk),
        titleMedium: TextStyle(fontWeight: FontWeight.w800, color: darkInk),
        bodyMedium: TextStyle(color: darkInk),
        bodySmall: TextStyle(color: darkMuted, fontWeight: FontWeight.w600),
        labelLarge: TextStyle(fontWeight: FontWeight.w800),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkInk,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: darkInk,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        indicatorColor: cyan.withValues(alpha: 0.18),
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected) ? darkInk : darkMuted,
            fontWeight:
                states.contains(WidgetState.selected)
                    ? FontWeight.w900
                    : FontWeight.w700,
            fontSize: 12,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? darkInk : darkMuted,
            size: 24,
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: darkSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: darkLine),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: cyan,
          foregroundColor: Colors.black,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkInk,
          minimumSize: const Size(48, 48),
          side: const BorderSide(color: darkLine),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cyan,
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        labelStyle: const TextStyle(
          color: darkMuted,
          fontWeight: FontWeight.w700,
        ),
        hintStyle: const TextStyle(color: darkMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkLine),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkLine),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: cyan, width: 1.4),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? darkInk : darkMuted,
          ),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected)
                    ? cyan.withValues(alpha: 0.18)
                    : darkSurface,
          ),
          side: WidgetStateProperty.all(const BorderSide(color: darkLine)),
          textStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceSoft,
        selectedColor: cyan.withValues(alpha: 0.20),
        disabledColor: darkLine,
        side: const BorderSide(color: darkLine),
        labelStyle: const TextStyle(
          color: darkInk,
          fontWeight: FontWeight.w800,
        ),
        secondaryLabelStyle: const TextStyle(
          color: darkInk,
          fontWeight: FontWeight.w800,
        ),
        iconTheme: const IconThemeData(color: cyan),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkInk,
        contentTextStyle: const TextStyle(color: darkCanvas),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: const DividerThemeData(color: darkLine, thickness: 1),
    );
  }
}

class AppMotion {
  static const fast = Duration(milliseconds: 180);
  static const standard = Duration(milliseconds: 260);
  static const slow = Duration(milliseconds: 420);
  static const curve = Curves.easeOutCubic;
}
