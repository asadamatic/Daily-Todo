
import 'package:dailytodo/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(DailyTodo());
}

class DailyTodo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Daily Todo',
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          color: Theme.of(context).primaryColor,
        ),
        bottomAppBarColor: Theme.of(context).primaryColor,
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
              shape:  MaterialStateProperty.all(RoundedRectangleBorder(
                  side: BorderSide(
                      color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(8.0)))
            ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.blue[400], brightness: Brightness.light),
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.blue[400],
          selectionHandleColor: Colors.blue[400],
        ),
      ),
      darkTheme: ThemeData(
          primaryColor: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.dark,
          appBarTheme: AppBarTheme(
            color: Colors.grey[800],
            foregroundColor: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
                shape:  MaterialStateProperty.all(RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0)))
            )
          ),
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.grey[800],
          ),
          bottomAppBarColor: Colors.grey[800],
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Colors.blue[400], brightness: Brightness.dark),
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.blue[400],
            selectionHandleColor: Colors.blue[400],
          ),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.black)),
      home: const Wrapper(),
    );
  }
}
