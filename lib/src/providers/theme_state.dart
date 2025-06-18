import 'package:zaplab_design/zaplab_design.dart';

class ThemeState {
  final LabThemeColorMode? colorMode;
  final LabTextScale textScale;
  final LabSystemScale systemScale;

  const ThemeState({
    this.colorMode,
    this.textScale = LabTextScale.normal,
    this.systemScale = LabSystemScale.normal,
  });

  ThemeState copyWith({
    LabThemeColorMode? Function()? colorMode,
    LabTextScale? textScale,
    LabSystemScale? systemScale,
  }) {
    return ThemeState(
      colorMode: colorMode != null ? colorMode() : this.colorMode,
      textScale: textScale ?? this.textScale,
      systemScale: systemScale ?? this.systemScale,
    );
  }
}
