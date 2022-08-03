import 'package:facebook/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData darkTheme = ThemeData(
  ///text theme
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      height: 1.3,
    ),
    subtitle1: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),

  ///scaffoldBackgroundColor theme
  scaffoldBackgroundColor: HexColor('333739'),

  ///primarySwatch theme
  primarySwatch: defaultColor,

  ///appbar theme
  appBarTheme: AppBarTheme(
    titleSpacing: 16.0,
    backgroundColor: HexColor('333739'),
    elevation: 0.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor('333739'),
      statusBarIconBrightness: Brightness.light,
    ),
    titleTextStyle: const TextStyle(
      fontFamily: 'Jannah',
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  ),

  ///bottom nav bar theme
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defaultColor,
    elevation: 20.0,
    backgroundColor: HexColor('333739'),
    unselectedItemColor: Colors.grey,
  ),

  ///font them
  fontFamily: 'Jannah',
);
ThemeData lightTheme = ThemeData(
  ///text theme
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      height: 1.3,
    ),
    subtitle1: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),

  ///scaffoldBackgroundColor theme
  scaffoldBackgroundColor: Colors.white,

  ///primarySwatch theme
  primarySwatch: defaultColor,

  ///appbar theme
  appBarTheme: const AppBarTheme(
    titleSpacing: 16.0,
    backgroundColor: Colors.white,
    elevation: 0.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    titleTextStyle: TextStyle(
      fontFamily: 'Jannah',
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),

  ///bottom nav bar theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defaultColor,
    elevation: 20.0,
    backgroundColor: Colors.white,
    unselectedItemColor: Colors.grey,
  ),

  ///font them
  fontFamily: 'Jannah',
);
