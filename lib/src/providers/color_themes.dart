import 'package:zaplab_design/zaplab_design.dart';

/// Defines all available color themes for the app
class ColorThemes {
  /// Get the color override for a specific theme name
  static LabColorsOverride? getOverride(String themeName) {
    switch (themeName) {
      case 'Blurple':
        return null; // Default, no override needed
      case 'Pink':
        return LabColorsOverride(
          blurple: LinearGradient(
            colors: [Color(0xFFE340A2), Color(0xFFD73E6C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          blurple66: LinearGradient(
            colors: [
              Color(0xFFE340A2).withValues(alpha: 0.66),
              Color(0xFFD73E6C).withValues(alpha: 0.66),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          blurple33: LinearGradient(
            colors: [
              Color(0xFFE340A2).withValues(alpha: 0.33),
              Color(0xFFD73E6C).withValues(alpha: 0.33)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          blurple16: LinearGradient(
            colors: [
              Color(0xFFE340A2).withValues(alpha: 0.16),
              Color(0xFFD73E6C).withValues(alpha: 0.16)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          blurpleColor: Color(0xFFE33F8A),
          blurpleColor66: Color(0xFFE33F8A).withValues(alpha: 0.66),
          blurpleColor33: Color(0xFFE33F8A).withValues(alpha: 0.33),
          blurpleLightColor: Color(0xFFFF58A4),
          blurpleLightColor66: Color(0xFFFF58A4).withValues(alpha: 0.66),
        );
      case 'Ocean':
        return LabColorsOverride(
          blurple:
              LinearGradient(colors: [Color(0xFF00956B), Color(0xFF1F749C)]),
          blurple66:
              LinearGradient(colors: [Color(0xFF00956B), Color(0xFF1F749C)]),
          blurple33:
              LinearGradient(colors: [Color(0xFF00956B), Color(0xFF1F749C)]),
          blurple16:
              LinearGradient(colors: [Color(0xFF00956B), Color(0xFF1F749C)]),
          blurpleColor: Color(0xFF128D8C),
          blurpleColor66: Color(0xFF128D8C).withValues(alpha: 0.66),
          blurpleColor33: Color(0xFF128D8C).withValues(alpha: 0.33),
          blurpleLightColor: Color(0xFF1EA1A0),
          blurpleLightColor66: Color(0xFF1EA1A0).withValues(alpha: 0.66),
        );
      case 'Bronze':
        return LabColorsOverride(
          blurple:
              LinearGradient(colors: [Color(0xFFA7801A), Color(0xFF9A620D)]),
          blurple66:
              LinearGradient(colors: [Color(0xFFA7801A), Color(0xFF9A620D)]),
          blurple33:
              LinearGradient(colors: [Color(0xFFA7801A), Color(0xFF9A620D)]),
          blurple16:
              LinearGradient(colors: [Color(0xFFA7801A), Color(0xFF9A620D)]),
          blurpleColor: Color(0xFFBC871E),
          blurpleColor66: Color(0xFFBC871E).withValues(alpha: 0.66),
          blurpleColor33: Color(0xFFBC871E).withValues(alpha: 0.33),
          blurpleLightColor: Color(0xFFDAA130),
          blurpleLightColor66: Color(0xFFDAA130).withValues(alpha: 0.66),
        );
      case 'Blue':
        return LabColorsOverride(
          blurple:
              LinearGradient(colors: [Color(0xFF3C4FFF), Color(0xFF3C2BF7)]),
          blurple66:
              LinearGradient(colors: [Color(0xFF3C4FFF), Color(0xFF3C2BF7)]),
          blurple33:
              LinearGradient(colors: [Color(0xFF3C4FFF), Color(0xFF3C2BF7)]),
          blurple16:
              LinearGradient(colors: [Color(0xFF3C4FFF), Color(0xFF3C2BF7)]),
          blurpleColor: Color(0xFF4434FF),
          blurpleColor66: Color(0xFF4434FF).withValues(alpha: 0.66),
          blurpleColor33: Color(0xFF4434FF).withValues(alpha: 0.33),
          blurpleLightColor: Color(0xFF6174FF),
          blurpleLightColor66: Color(0xFF6174FF).withValues(alpha: 0.66),
        );

      default:
        return null;
    }
  }

  /// Get all available theme names
  static List<String> get availableThemes => [
        'Blurple',
        'Pink',
        'Ocean',
        'Bronze',
        'Blue',
      ];

  /// Get the gradient for a theme (for UI preview)
  static Gradient getGradient(String themeName) {
    switch (themeName) {
      case 'Blurple':
        return LabColorsData.light().blurple;
      case 'Pink':
        return LinearGradient(
          colors: [Color(0xFFE340A2), Color(0xFFD73E6C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      case 'Ocean':
        return LinearGradient(
          colors: [Color(0xFF00956B), Color(0xFF1F749C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Bronze':
        return LinearGradient(
          colors: [Color(0xFFA7801A), Color(0xFF9A620D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Blue':
        return LinearGradient(
          colors: [Color(0xFF3C4FFF), Color(0xFF3C2BF7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LabColorsData.light().blurple;
    }
  }
}
