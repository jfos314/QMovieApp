import 'package:flutter/material.dart';

import '../helpers/my_const.dart' as consts;

class QThemeData {
  ThemeData themeDataDark = ThemeData(
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: consts.primaryColor,
      brightness: Brightness.dark,
      primary: consts.primaryColor,
      secondary: consts.secondaryColor,
      background: consts.backgroundColor,
    ),
    primarySwatch: Colors.amber,
    scaffoldBackgroundColor: consts.backgroundColor,
    textTheme: const TextTheme(
      headline1: TextStyle(
          color: consts.textColor, fontSize: 22, fontWeight: FontWeight.w600),
      headline2: TextStyle(
          color: consts.textColor, fontSize: 15, fontWeight: FontWeight.w600),
      headline3: TextStyle(
          color: consts.textColor, fontSize: 22, fontWeight: FontWeight.w600),
      bodyText1: TextStyle(
          color: consts.textColor, fontSize: 13, fontWeight: FontWeight.w300),
      subtitle1: TextStyle(
          color: consts.textColor, fontSize: 12, fontWeight: FontWeight.w400),
      subtitle2: TextStyle(
          color: consts.textColor, fontSize: 11, fontWeight: FontWeight.w400),
    ),
  );
}
