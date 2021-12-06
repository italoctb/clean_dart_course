import 'package:clean_dart_course/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(136, 14, 79, 1);
    const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
    const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);
    // ignore: avoid_unnecessary_containers
    return MaterialApp(
      title: "CleanDartApp",
      home: LoginPage(null),
      theme: ThemeData(
          primaryColor: primaryColor,
          primaryColorDark: primaryColorDark,
          primaryColorLight: primaryColorLight,
          backgroundColor: Colors.white,
          textTheme: const TextTheme(
            headline1: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: primaryColorDark),
          ),
          inputDecorationTheme: const InputDecorationTheme(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColorLight,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColorDark),
              ),
              alignLabelWithHint: true,
              focusColor: primaryColorDark,
              floatingLabelStyle: TextStyle(color: primaryColorDark)),
          buttonTheme: ButtonThemeData(
            colorScheme: const ColorScheme.light(primary: primaryColor),
            buttonColor: primaryColor,
            splashColor: primaryColorLight,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          )),
    );
  }
}
