// ignore_for_file: invalid_use_of_protected_member

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'theme_state.dart';

part 'theme_settings.g.dart';

@riverpod
class ThemeSettings extends _$ThemeSettings {
  static const _themeKey = 'theme_mode';
  static const _textScaleKey = 'text_scale';
  static const _systemScaleKey = 'system_scale';

  @override
  Future<ThemeState> build() async {
    final prefs = await SharedPreferences.getInstance();

    // Load theme
    final savedTheme = prefs.getString(_themeKey);
    final themeMode = savedTheme != null
        ? AppThemeColorMode.values.firstWhere((e) => e.name == savedTheme)
        : null;

    // Load text scale
    final savedTextScale = prefs.getString(_textScaleKey);
    final textScale = savedTextScale != null
        ? AppTextScale.values.firstWhere((e) => e.name == savedTextScale)
        : AppTextScale.normal;

    // Load system scale
    final savedSystemScale = prefs.getString(_systemScaleKey);
    final systemScale = savedSystemScale != null
        ? AppSystemScale.values.firstWhere((e) => e.name == savedSystemScale)
        : AppSystemScale.normal;

    return ThemeState(
      colorMode: themeMode,
      textScale: textScale,
      systemScale: systemScale,
    );
  }

  Future<void> setTheme(AppThemeColorMode? mode) async {
    final prefs = await SharedPreferences.getInstance();
    if (mode == null) {
      await prefs.remove(_themeKey);
    } else {
      await prefs.setString(_themeKey, mode.name);
    }
    final currentState = state.value!;
    state = AsyncValue.data(currentState.copyWith(
      colorMode: () => mode,
    ));
  }

  Future<void> setTextScale(AppTextScale scale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_textScaleKey, scale.name);
    final currentState = state.value!;
    state = AsyncValue.data(currentState.copyWith(
      textScale: scale,
    ));
  }

  Future<void> setSystemScale(AppSystemScale scale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_systemScaleKey, scale.name);
    final currentState = state.value!;
    state = AsyncValue.data(currentState.copyWith(
      systemScale: scale,
    ));
  }
}
