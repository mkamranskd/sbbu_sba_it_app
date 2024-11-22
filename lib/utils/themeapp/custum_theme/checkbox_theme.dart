import 'package:flutter/material.dart';

/// Custom Class for Light & Dark Checkbox Themes
class ITCheckboxTheme {
  ITCheckboxTheme._(); // To avoid creating instances

  /// Customizable Light Checkbox Theme
  static final CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    checkColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.white;
      } else {
        return Colors.black; // Corrected from Colors.block to Colors.black
      }
    }),
    fillColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.blue;
      } else {
        return Colors.transparent;
      }
    }),
  );

  /// Customizable Dark Checkbox Theme
  static final CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    checkColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.white;
      } else {
        return Colors.black;
      }
    }),
    fillColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.blue;
      } else {
        return Colors.transparent;
      }
    }),
  );
}
