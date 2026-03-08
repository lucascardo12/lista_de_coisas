import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listadecoisa/core/interfaces/service_interface.dart';
import 'package:listadecoisa/core/services/theme/theme_enum.dart';

class ThemeService extends IService {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  // Método estático para acesso direto ao singleton
  static ThemeService get of => _instance;

  late Box box;
  ValueNotifier<ThemeEnum> currentTheme = ValueNotifier(ThemeEnum.original);

  static const Map<ThemeEnum, Map<String, Color>> _themes = {
    ThemeEnum.original: {
      'primary': Color.fromRGBO(255, 64, 111, 1),
      'secondary': Color.fromRGBO(255, 128, 111, 1),
      'whiteOrBlack': Colors.white,
      'textColor': Color(0xFF2C3E50),
      'secondaryTextColor': Color(0xFF757575),
      'backgroundColor': Color(0xFFFAFAFA),
      'surfaceColor': Colors.white,
    },
    ThemeEnum.dark: {
      'primary': Color(0xFF212121),
      'secondary': Color(0xFF484848),
      'whiteOrBlack': Colors.white,
      'textColor': Colors.white,
      'secondaryTextColor': Colors.white70,
      'backgroundColor': Color(0xFF121212),
      'surfaceColor': Color(0xFF1E1E1E),
    },
    ThemeEnum.blue: {
      'primary': Color.fromRGBO(89, 165, 216, 1),
      'secondary': Color.fromRGBO(145, 229, 246, 1),
      'whiteOrBlack': Colors.white,
      'textColor': Color(0xFF2C3E50),
      'secondaryTextColor': Color(0xFF757575),
      'backgroundColor': Color(0xFFFAFAFA),
      'surfaceColor': Colors.white,
    },
    ThemeEnum.purple: {
      'primary': Color.fromRGBO(90, 24, 154, 1),
      'secondary': Color.fromRGBO(157, 78, 221, 1),
      'whiteOrBlack': Colors.white,
      'textColor': Color(0xFF2C3E50),
      'secondaryTextColor': Color(0xFF757575),
      'backgroundColor': Color(0xFFFAFAFA),
      'surfaceColor': Colors.white,
    },
  };

  @override
  Future<void> start() async {
    box = await Hive.openBox('theme');
    currentTheme.value = ThemeEnum.values.firstWhere(
      (element) =>
          element.name ==
          box.get('tema', defaultValue: ThemeEnum.original.name),
    );
  }

  Future<void> setTheme(ThemeEnum themeName) async {
    if (_themes.containsKey(themeName)) {
      currentTheme.value = themeName;
      await box.put('tema', themeName.name);
    }
  }

  ThemeEnum getCurrentTheme() => currentTheme.value;

  List<ThemeEnum> getAvailableThemes() => _themes.keys.toList();

  Color get primary =>
      _themes[currentTheme.value]?['primary'] ??
      _themes[ThemeEnum.original]!['primary']!;

  Color get secondary =>
      _themes[currentTheme.value]?['secondary'] ??
      _themes[ThemeEnum.original]!['secondary']!;

  Color get whiteOrBlack =>
      _themes[currentTheme.value]?['whiteOrBlack'] ??
      _themes[ThemeEnum.original]!['whiteOrBlack']!;

  Color get textColor =>
      _themes[currentTheme.value]?['textColor'] ??
      _themes[ThemeEnum.original]!['textColor']!;

  Color get secondaryTextColor =>
      _themes[currentTheme.value]?['secondaryTextColor'] ??
      _themes[ThemeEnum.original]!['secondaryTextColor']!;

  Color get backgroundColor =>
      _themes[currentTheme.value]?['backgroundColor'] ??
      _themes[ThemeEnum.original]!['backgroundColor']!;

  Color get surfaceColor =>
      _themes[currentTheme.value]?['surfaceColor'] ??
      _themes[ThemeEnum.original]!['surfaceColor']!;

  Color get successColor => Colors.green;

  Color get errorColor => Colors.red;

  Color get warningColor => Colors.orange;

  Color get infoColor => Colors.blue;

  ThemeData get getTheme {
    if (currentTheme.value.isDark) {
      return getDarkTheme();
    }
    return getLightTheme();
  }

  ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: backgroundColor,
        onSurface: textColor,
        onPrimary: whiteOrBlack,
        onSecondary: whiteOrBlack,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: whiteOrBlack,
        elevation: 0,
      ),
      cardTheme: CardThemeData(color: backgroundColor, elevation: 2),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: whiteOrBlack,
        ),
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primary,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: backgroundColor,
        onSurface: textColor,
        onPrimary: whiteOrBlack,
        onSecondary: whiteOrBlack,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: whiteOrBlack,
        elevation: 0,
      ),
      cardTheme: CardThemeData(color: backgroundColor, elevation: 2),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: whiteOrBlack,
        ),
      ),
    );
  }
}
