import 'package:zaplab_design/zaplab_design.dart';

class ThemeState {
  final AppThemeColorMode? colorMode;
  final AppTextScale textScale;
  final AppSystemScale systemScale;

  const ThemeState({
    this.colorMode,
    this.textScale = AppTextScale.normal,
    this.systemScale = AppSystemScale.normal,
  });

  ThemeState copyWith({
    AppThemeColorMode? Function()? colorMode,
    AppTextScale? textScale,
    AppSystemScale? systemScale,
  }) {
    return ThemeState(
      colorMode: colorMode != null ? colorMode() : this.colorMode,
      textScale: textScale ?? this.textScale,
      systemScale: systemScale ?? this.systemScale,
    );
  }
}
