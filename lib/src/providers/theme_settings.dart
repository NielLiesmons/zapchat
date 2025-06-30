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

    return ThemeState(
      colorMode: themeMode,
      textScale: textScale,
      systemScale: systemScale,
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
}
