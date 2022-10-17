import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      textTheme: GoogleFonts.promptTextTheme(
        Theme.of(context).textTheme,
      ),
      buttonTheme: const ButtonThemeData(buttonColor: Colors.yellowAccent),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        minimumSize: const Size(88, 36),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      )),
      appBarTheme: const AppBarTheme(
        color: Color.fromARGB(255, 0, 40, 72),
        elevation: 0,
        
        iconTheme: IconThemeData(color: Colors.white),
      ));

}
