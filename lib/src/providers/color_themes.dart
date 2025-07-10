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
          blurple66: LinearGradient(colors: [
            Color(0xFF00956B).withValues(alpha: 0.66),
            Color(0xFF1F749C).withValues(alpha: 0.66)
          ]),
          blurple33: LinearGradient(colors: [
            Color(0xFF00956B).withValues(alpha: 0.33),
            Color(0xFF1F749C).withValues(alpha: 0.33)
          ]),
          blurple16: LinearGradient(colors: [
            Color(0xFF00956B).withValues(alpha: 0.16),
            Color(0xFF1F749C).withValues(alpha: 0.16)
          ]),
          blurpleColor: Color(0xFF128D8C),
          blurpleColor66: Color(0xFF128D8C).withValues(alpha: 0.66),
          blurpleColor33: Color(0xFF128D8C).withValues(alpha: 0.33),
          blurpleLightColor: Color(0xFF128D8C),
          blurpleLightColor66: Color(0xFF128D8C).withValues(alpha: 0.66),
          gold: LinearGradient(colors: [Color(0xFFE08B2A), Color(0xFFCF585C)]),
          gold66: LinearGradient(colors: [
            Color(0xFFE08B2A).withValues(alpha: 0.66),
            Color(0xFFCF585C).withValues(alpha: 0.66)
          ]),
          gold33: LinearGradient(colors: [
            Color(0xFFE08B2A).withValues(alpha: 0.33),
            Color(0xFFCF585C).withValues(alpha: 0.33)
          ]),
          gold16: LinearGradient(colors: [
            Color(0xFFE08B2A).withValues(alpha: 0.16),
            Color(0xFFCF585C).withValues(alpha: 0.16)
          ]),
          goldColor: Color(0xFFD87143),
          goldColor66: Color(0xFFD87143).withValues(alpha: 0.66),
          rouge: LinearGradient(colors: [Color(0xFFCF58B6), Color(0xFFDB465F)]),
          rouge66: LinearGradient(colors: [
            Color(0xFFCF58B6).withValues(alpha: 0.66),
            Color(0xFFDB465F).withValues(alpha: 0.66)
          ]),
          rouge33: LinearGradient(colors: [
            Color(0xFFCF58B6).withValues(alpha: 0.33),
            Color(0xFFDB465F).withValues(alpha: 0.33)
          ]),
          rouge16: LinearGradient(colors: [
            Color(0xFFCF58B6).withValues(alpha: 0.16),
            Color(0xFFDB465F).withValues(alpha: 0.16)
          ]),
        );
      case 'Bronze':
        return LabColorsOverride(
          blurple:
              LinearGradient(colors: [Color(0xFFEC7347), Color(0xFFC6492F)]),
          blurple66: LinearGradient(colors: [
            Color(0xFFEC7347).withValues(alpha: 0.66),
            Color(0xFFC6492F).withValues(alpha: 0.66)
          ]),
          blurple33: LinearGradient(colors: [
            Color(0xFFEC7347).withValues(alpha: 0.33),
            Color(0xFFC6492F).withValues(alpha: 0.33)
          ]),
          blurple16: LinearGradient(colors: [
            Color(0xFFEC7347).withValues(alpha: 0.16),
            Color(0xFFC6492F).withValues(alpha: 0.16)
          ]),
          blurpleColor: Color(0xFFE55D37),
          blurpleColor66: Color(0xFFE55D37).withValues(alpha: 0.66),
          blurpleColor33: Color(0xFFE55D37).withValues(alpha: 0.33),
          blurpleLightColor: Color(0xFFE55D37),
          blurpleLightColor66: Color(0xFFE55D37).withValues(alpha: 0.66),
          gold: LinearGradient(colors: [Color(0xFF43A3EA), Color(0xFF5747D1)]),
          gold66: LinearGradient(colors: [
            Color(0xFF43A3EA).withValues(alpha: 0.66),
            Color(0xFF5747D1).withValues(alpha: 0.66)
          ]),
          gold33: LinearGradient(colors: [
            Color(0xFF43A3EA).withValues(alpha: 0.33),
            Color(0xFF5747D1).withValues(alpha: 0.33)
          ]),
          gold16: LinearGradient(colors: [
            Color(0xFF43A3EA).withValues(alpha: 0.16),
            Color(0xFF5747D1).withValues(alpha: 0.16)
          ]),
          goldColor: Color(0xFF4D75DE),
          goldColor66: Color(0xFF4D75DE).withValues(alpha: 0.66),
        );
      case 'Blue':
        return LabColorsOverride(
          blurple:
              LinearGradient(colors: [Color(0xFF3C4FFF), Color(0xFF3C2BF7)]),
          blurple66: LinearGradient(colors: [
            Color(0xFF3C4FFF).withValues(alpha: 0.66),
            Color(0xFF3C2BF7).withValues(alpha: 0.66)
          ]),
          blurple33: LinearGradient(colors: [
            Color(0xFF3C4FFF).withValues(alpha: 0.33),
            Color(0xFF3C2BF7).withValues(alpha: 0.33)
          ]),
          blurple16: LinearGradient(colors: [
            Color(0xFF3C4FFF).withValues(alpha: 0.16),
            Color(0xFF3C2BF7).withValues(alpha: 0.16)
          ]),
          blurpleColor: Color(0xFF4434FF),
          blurpleColor66: Color(0xFF4434FF).withValues(alpha: 0.66),
          blurpleColor33: Color(0xFF4434FF).withValues(alpha: 0.33),
          blurpleLightColor: Color(0xFF6174FF),
          blurpleLightColor66: Color(0xFF6174FF).withValues(alpha: 0.66),
        );
      case 'Purple':
        return LabColorsOverride(
          blurple:
              LinearGradient(colors: [Color(0xFF8A3DE9), Color(0xFF713DE9)]),
          blurple66: LinearGradient(colors: [
            Color(0xFF8A3DE9).withValues(alpha: 0.66),
            Color(0xFF713DE9).withValues(alpha: 0.66)
          ]),
          blurple33: LinearGradient(colors: [
            Color(0xFF8A3DE9).withValues(alpha: 0.33),
            Color(0xFF713DE9).withValues(alpha: 0.33)
          ]),
          blurple16: LinearGradient(colors: [
            Color(0xFF8A3DE9).withValues(alpha: 0.16),
            Color(0xFF713DE9).withValues(alpha: 0.16)
          ]),
          blurpleColor: Color(0xFF7D3DE9),
          blurpleColor66: Color(0xFF7D3DE9).withValues(alpha: 0.66),
          blurpleColor33: Color(0xFF7D3DE9).withValues(alpha: 0.33),
          blurpleLightColor: Color(0xFF9657FF),
          blurpleLightColor66: Color(0xFF9657FF).withValues(alpha: 0.66),
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
        'Purple',
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
        return LinearGradient(colors: [Color(0xFFEC7347), Color(0xFFC6492F)]);

      case 'Blue':
        return LinearGradient(
          colors: [Color(0xFF3C4FFF), Color(0xFF3C2BF7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Purple':
        return LinearGradient(
          colors: [Color(0xFF8A3DE9), Color(0xFF713DE9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LabColorsData.light().blurple;
    }
  }
}
