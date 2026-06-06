import 'package:flutter/material.dart';

class AppTheme {
  static const ink = Color(0xFF1D1D1F);
  static const muted = Color(0xFF6E6E73);
  static const subtle = Color(0xFF8E8E93);
  static const line = Color(0xFFE0E0E0);
  static const canvas = Color(0xFFF5F5F7);
  static const surface = Colors.white;
  static const surfaceSoft = Color(0xFFFAFAFA);
  static const accentLight = Color(0xFF059669);
  static const accentDark = Color(0xFF10B981);
  static const accentHoverLight = Color(0xFF047857);
  static const accentHoverDark = Color(0xFF34D399);
  static const accentMutedLight = Color(0xFFD1FAE5);
  static const accentMutedDark = Color(0xFF064E3B);
  static const cyan = accentDark;
  static const mint = Color(0xFF22C55E);
  static const coral = Color(0xFFEF4444);
  static const amber = Color(0xFFF59E0B);
  static const violet = Color(0xFF10B981);
  static const electric = Color(0xFF34D399);
  static const darkInk = Color(0xFFF4F4F6);
  static const darkMuted = Color(0xFFA1A1AA);
  static const darkSubtle = Color(0xFF71717A);
  static const darkLine = Color(0xFF27272A);
  static const darkCanvas = Color(0xFF08080C);
  static const darkSurface = Color(0xFF0F0F14);
  static const darkSurfaceSoft = Color(0xFF16161C);
  static const commandLight = Color(0xFF1D1D1F);
  static const commandDark = Color(0xFF050508);

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color text(BuildContext context) => isDark(context) ? darkInk : ink;

  static Color mutedText(BuildContext context) =>
      isDark(context) ? darkMuted : muted;

  static Color subtleText(BuildContext context) =>
      isDark(context) ? darkSubtle : subtle;

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

  static Color commandSurface(BuildContext context) =>
      isDark(context) ? commandDark : commandLight;

  static Color onCommand(BuildContext context) => Colors.white;

  static Color accent(BuildContext context) =>
      isDark(context) ? accentDark : accentLight;

  static Color accentHover(BuildContext context) =>
      isDark(context) ? accentHoverDark : accentHoverLight;

  static Color accentMuted(BuildContext context) =>
      isDark(context) ? accentMutedDark : accentMutedLight;

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
      seedColor: accentLight,
      brightness: Brightness.light,
      primary: accentLight,
      secondary: accentHoverLight,
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
        displaySmall: TextStyle(fontWeight: FontWeight.w600, color: ink),
        headlineSmall: TextStyle(fontWeight: FontWeight.w600, color: ink),
        titleLarge: TextStyle(fontWeight: FontWeight.w600, color: ink),
        titleMedium: TextStyle(fontWeight: FontWeight.w600, color: ink),
        bodyMedium: TextStyle(color: ink),
        bodySmall: TextStyle(color: muted, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontWeight: FontWeight.w500),
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
          fontWeight: FontWeight.w600,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: accentMutedLight,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected) ? ink : muted,
            fontWeight:
                states.contains(WidgetState.selected)
                    ? FontWeight.w600
                    : FontWeight.w400,
            fontSize: 12,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? accentLight : muted,
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
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          minimumSize: const Size(48, 48),
          side: const BorderSide(color: line),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentLight,
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
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
          borderSide: const BorderSide(color: accentLight, width: 1.4),
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
                    ? accentMutedLight
                    : surface,
          ),
          side: WidgetStateProperty.all(const BorderSide(color: line)),
          textStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceSoft,
        selectedColor: accentMutedLight,
        disabledColor: line,
        side: const BorderSide(color: line),
        labelStyle: const TextStyle(color: ink, fontWeight: FontWeight.w500),
        secondaryLabelStyle: const TextStyle(
          color: ink,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: const IconThemeData(color: accentLight),
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
      seedColor: accentDark,
      brightness: Brightness.dark,
      primary: accentDark,
      secondary: accentHoverDark,
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
        displaySmall: TextStyle(fontWeight: FontWeight.w600, color: darkInk),
        headlineSmall: TextStyle(fontWeight: FontWeight.w600, color: darkInk),
        titleLarge: TextStyle(fontWeight: FontWeight.w600, color: darkInk),
        titleMedium: TextStyle(fontWeight: FontWeight.w600, color: darkInk),
        bodyMedium: TextStyle(color: darkInk),
        bodySmall: TextStyle(color: darkMuted, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontWeight: FontWeight.w500),
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
          fontWeight: FontWeight.w600,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        indicatorColor: accentMutedDark,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected) ? darkInk : darkMuted,
            fontWeight:
                states.contains(WidgetState.selected)
                    ? FontWeight.w600
                    : FontWeight.w400,
            fontSize: 12,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color:
                states.contains(WidgetState.selected) ? accentDark : darkMuted,
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
          backgroundColor: accentDark,
          foregroundColor: darkCanvas,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkInk,
          minimumSize: const Size(48, 48),
          side: const BorderSide(color: darkLine),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentDark,
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        labelStyle: const TextStyle(
          color: darkMuted,
          fontWeight: FontWeight.w500,
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
          borderSide: const BorderSide(color: accentDark, width: 1.4),
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
                    ? accentMutedDark
                    : darkSurface,
          ),
          side: WidgetStateProperty.all(const BorderSide(color: darkLine)),
          textStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceSoft,
        selectedColor: accentMutedDark,
        disabledColor: darkLine,
        side: const BorderSide(color: darkLine),
        labelStyle: const TextStyle(
          color: darkInk,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: darkInk,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: const IconThemeData(color: accentDark),
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
