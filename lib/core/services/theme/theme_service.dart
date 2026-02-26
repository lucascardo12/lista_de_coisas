import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listadecoisa/core/interfaces/service_interface.dart';
import 'package:listadecoisa/core/services/theme/theme_enum.dart';

class ThemeService extends IService {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  // Método estático para acesso direto ao singleton
  static ThemeService get instance => _instance;

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

  Color getPrimary() {
    return _themes[currentTheme.value]?['primary'] ??
        _themes[ThemeEnum.original]!['primary']!;
  }

  Color getSecondary() {
    return _themes[currentTheme.value]?['secondary'] ??
        _themes[ThemeEnum.original]!['secondary']!;
  }

  Color getWhiteOrBlack() {
    return _themes[currentTheme.value]?['whiteOrBlack'] ??
        _themes[ThemeEnum.original]!['whiteOrBlack']!;
  }

  Color getTextColor() {
    return _themes[currentTheme.value]?['textColor'] ??
        _themes[ThemeEnum.original]!['textColor']!;
  }

  Color getSecondaryTextColor() {
    return _themes[currentTheme.value]?['secondaryTextColor'] ??
        _themes[ThemeEnum.original]!['secondaryTextColor']!;
  }

  Color getBackgroundColor() {
    return _themes[currentTheme.value]?['backgroundColor'] ??
        _themes[ThemeEnum.original]!['backgroundColor']!;
  }

  Color getSurfaceColor() {
    return _themes[currentTheme.value]?['surfaceColor'] ??
        _themes[ThemeEnum.original]!['surfaceColor']!;
  }

  Color getSuccessColor() => Colors.green;

  Color getErrorColor() => Colors.red;

  Color getWarningColor() => Colors.orange;

  Color getInfoColor() => Colors.blue;

  ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: getPrimary(),
      colorScheme: ColorScheme.light(
        primary: getPrimary(),
        secondary: getSecondary(),
        surface: getSurfaceColor(),
        onSurface: getTextColor(),
        onPrimary: getWhiteOrBlack(),
        onSecondary: getWhiteOrBlack(),
        error: getErrorColor(),
      ),
      scaffoldBackgroundColor: getBackgroundColor(),
      appBarTheme: AppBarTheme(
        backgroundColor: getPrimary(),
        foregroundColor: getWhiteOrBlack(),
        elevation: 0,
      ),
      cardTheme: CardThemeData(color: getSurfaceColor(), elevation: 2),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: getPrimary(),
          foregroundColor: getWhiteOrBlack(),
        ),
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: getPrimary(),
      colorScheme: ColorScheme.dark(
        primary: getPrimary(),
        secondary: getSecondary(),
        surface: getSurfaceColor(),
        onSurface: getTextColor(),
        onPrimary: getWhiteOrBlack(),
        onSecondary: getWhiteOrBlack(),
        error: getErrorColor(),
      ),
      scaffoldBackgroundColor: getBackgroundColor(),
      appBarTheme: AppBarTheme(
        backgroundColor: getPrimary(),
        foregroundColor: getWhiteOrBlack(),
        elevation: 0,
      ),
      cardTheme: CardThemeData(color: getSurfaceColor(), elevation: 2),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: getPrimary(),
          foregroundColor: getWhiteOrBlack(),
        ),
      ),
    );
  }
}
