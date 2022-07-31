import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppPattern{
  //0xFF262626
  static Color mainColor = const Color(0xFF262626);
  // static Color secondaryColor = const Color(0xFFD9D9D9);
  static Color? secondaryColor = Colors.grey[400];
  static Color darkGreenColor = const Color(0xFF3D7340);
  static Color lightGreenColor = const Color(0xFF84D98A);
  static Color midGreenColor = const Color(0xFF75BF7A);

  static ThemeData darkTheme = ThemeData(
    primarySwatch: createMaterialColor(midGreenColor),
    scaffoldBackgroundColor: mainColor,
    listTileTheme: ListTileThemeData(
      tileColor: mainColor,
      textColor: secondaryColor,
      iconColor: lightGreenColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: mainColor,
      foregroundColor: secondaryColor,
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: mainColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      elevation: 0,
    ),
    iconTheme: IconThemeData(
      color: secondaryColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: mainColor,
      backgroundColor: secondaryColor,
    ),
    cardColor: secondaryColor,
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: GoogleFonts.cairo(
        color: secondaryColor,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: darkGreenColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: lightGreenColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: darkGreenColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      hoverColor: lightGreenColor.withOpacity(0.5),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(mainColor),
        backgroundColor: MaterialStateProperty.all(secondaryColor),
      ),
    ),
  );

  static double kPadding = 20.0;

  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}