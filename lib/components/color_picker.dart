import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class ColorPickerProvider extends ChangeNotifier {
  List<Color> _originalColors = [];
  List<double> _hues = [];
  List<double> _opacities = [];

  List<Color> get originalColors => _originalColors;
  List<double> get hues => _hues;
  List<double> get opacities => _opacities;

  void initializeColors(List<Color> initialColors) {
    _originalColors = initialColors;
    _hues = List.generate(initialColors.length, (index) => 0.0);
    _opacities = List.generate(initialColors.length, (index) => 1.0);
    notifyListeners();
  }

  Future<void> extractColorsFromImage(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
      imageProvider,
      maximumColorCount: 5, // Set maximum colors to extract
    );

    List<Color> extractedColors = paletteGenerator.colors.toList();
    initializeColors(extractedColors);
  }

  void updateHue(int index, double value) {
    _hues[index] = value;
    notifyListeners();
  }

  void updateOpacity(int index, double value) {
    _opacities[index] = value;
    notifyListeners();
  }

  Color getAdjustedColor(int index) {
    final originalColor = _originalColors[index];
    final hue = _hues[index];
    final opacity = _opacities[index];

    final hsvColor = HSVColor.fromColor(originalColor).withHue(hue);
    final colorWithHue = hsvColor.toColor();
    final colorWithOpacity = colorWithHue.withOpacity(opacity);

    return colorWithOpacity;
  }
}
