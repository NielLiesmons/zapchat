import 'package:zaplab_design/zaplab_design.dart';

class ThemeState {
  final LabThemeColorMode? colorMode;
  final LabTextScale textScale;
  final LabSystemScale systemScale;
  final LabColorsOverride? colorsOverride;
  final String colorThemeName;

  const ThemeState({
    this.colorMode,
    this.textScale = LabTextScale.normal,
    this.systemScale = LabSystemScale.normal,
    this.colorsOverride,
    this.colorThemeName = 'Blurple',
  });

  ThemeState copyWith({
    LabThemeColorMode? Function()? colorMode,
    LabTextScale? textScale,
    LabSystemScale? systemScale,
    LabColorsOverride? colorsOverride,
    String? colorThemeName,
  }) {
    return ThemeState(
      colorMode: colorMode != null ? colorMode() : this.colorMode,
      textScale: textScale ?? this.textScale,
      systemScale: systemScale ?? this.systemScale,
      colorsOverride: colorsOverride,
      colorThemeName: colorThemeName ?? this.colorThemeName,
    );
  }
}
