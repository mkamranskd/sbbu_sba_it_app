import 'package:flutter/material.dart';
import 'package:sbbu_sba_it_app/utils/themeapp/custum_theme/text_theme.dart';
import 'custum_theme/elevated_botton_theme.dart';
import 'custum_theme/appbartheme.dart';
import 'custum_theme/bottom_theme_sheet.dart';
import 'custum_theme/checkbox_theme.dart';
import 'custum_theme/chip_theme.dart';
import 'custum_theme/text_field_theme.dart';

class ITAppTheme {
  ITAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: ITTextTheme.lightTextTheme,
    elevatedButtonTheme: ITElevatedButtonTheme.lightElevatedButtonTheme,
    checkboxTheme: ITCheckboxTheme.lightCheckboxTheme,
    appBarTheme: ITAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: ITBottomSheetTheme.lightBottomSheetTheme,
    chipTheme: ITChipTheme.lightChipTheme,
    inputDecorationTheme: ITTextFormFieldTheme.lightInputDecorationTheme,

  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: ITTextTheme.darkTextTheme,
    elevatedButtonTheme: ITElevatedButtonTheme.darkElevatedButtonTheme,
    checkboxTheme: ITCheckboxTheme.darkCheckboxTheme,
    appBarTheme: ITAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: ITBottomSheetTheme.darkBottomSheetTheme,
    chipTheme: ITChipTheme.darkChipTheme,
  );
}
