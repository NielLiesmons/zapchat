import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'theme_state.dart';
import 'color_themes.dart';

part 'theme_settings.g.dart';

@riverpod
class ThemeSettings extends _$ThemeSettings {
  static const _themeKey = 'theme_mode';
  static const _textScaleKey = 'text_scale';
  static const _systemScaleKey = 'system_scale';
  static const _colorThemeKey = 'color_theme';

  @override
  Future<ThemeState> build() async {
    final prefs = await SharedPreferences.getInstance();

    // Load theme
    final savedTheme = prefs.getString(_themeKey);
    LabThemeColorMode? themeMode;

    if (savedTheme != null) {
      themeMode =
          LabThemeColorMode.values.firstWhere((e) => e.name == savedTheme);
    } else {
      // Set platform-specific defaults when no saved preference
      if (LabPlatformUtils.isMobile) {
        themeMode = LabThemeColorMode.dark;
      } else {
        themeMode = LabThemeColorMode.gray;
      }
    }

    // Load text scale
    final savedTextScale = prefs.getString(_textScaleKey);
    final textScale = savedTextScale != null
        ? LabTextScale.values.firstWhere((e) => e.name == savedTextScale)
        : LabTextScale.normal;

    // Load system scale
    final savedSystemScale = prefs.getString(_systemScaleKey);
    final systemScale = savedSystemScale != null
        ? LabSystemScale.values.firstWhere((e) => e.name == savedSystemScale)
        : LabSystemScale.normal;

    // Load color theme override
    final savedColorTheme = prefs.getString(_colorThemeKey);
    LabColorsOverride? colorsOverride;

    if (savedColorTheme != null && savedColorTheme != 'Blurple') {
      colorsOverride = ColorThemes.getOverride(savedColorTheme);
    }

    return ThemeState(
      colorMode: themeMode,
      textScale: textScale,
      systemScale: systemScale,
      colorsOverride: colorsOverride,
    );
  }

  Future<void> setTheme(LabThemeColorMode? mode) async {
    final prefs = await SharedPreferences.getInstance();
    if (mode == null) {
      await prefs.remove(_themeKey);
    } else {
      await prefs.setString(_themeKey, mode.name);
    }
    final currentState = state.value!;
    state = AsyncValue.data(currentState.copyWith(
      colorMode: () => mode,
      colorsOverride: currentState.colorsOverride,
    ));
  }

  Future<void> setTextScale(LabTextScale scale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_textScaleKey, scale.name);
    final currentState = state.value!;
    state = AsyncValue.data(currentState.copyWith(
      textScale: scale,
    ));
  }

  Future<void> setSystemScale(LabSystemScale scale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_systemScaleKey, scale.name);
    final currentState = state.value!;
    state = AsyncValue.data(currentState.copyWith(
      systemScale: scale,
    ));
  }

  Future<void> setColorTheme(String colorThemeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_colorThemeKey, colorThemeName);

    final currentState = state.value!;
    final colorsOverride = colorThemeName == 'Blurple'
        ? null
        : ColorThemes.getOverride(colorThemeName);

    state = AsyncValue.data(currentState.copyWith(
      colorsOverride: colorsOverride,
    ));
  }

  /// Get the current color theme name from SharedPreferences
  Future<String> getCurrentColorTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_colorThemeKey) ?? 'Blurple';
  }

  /// Get the current color theme name synchronously from the current state
  String getCurrentColorThemeSync() {
    final currentState = state.value;
    if (currentState == null) {
      return 'Blurple';
    }

    // If there's no override, it's Blurple
    if (currentState.colorsOverride == null) {
      return 'Blurple';
    }

    // For now, return Blurple as default since we don't have a reverse lookup
    // In a real implementation, you'd want to store the theme name in the state
    return 'Blurple';
  }
}
