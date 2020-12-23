import 'package:dailytodo/LocalDatabase/LocalDatabase.dart';
import 'package:dailytodo/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ValueNotifier<bool>>.value(
      value: ValueNotifier<bool>(false),
      builder: (context, widget){

        return ThemeProvider(
          saveThemesOnChange: true,
          themes: [
            AppTheme(
              description: 'Light theme for app',
              id: 'custom_light_theme',
              data: ThemeData(
                  primaryColor: Colors.blue,
                  accentColor: Colors.blue[400],
                  textSelectionColor: Colors.blue[400],
                  textSelectionHandleColor: Colors.blue[400],
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  brightness: Brightness.light,
                  appBarTheme: AppBarTheme(
                    color: Theme.of(context).primaryColor,
                  ),
                  bottomAppBarColor: Theme.of(context).primaryColor,
              ),
            ),AppTheme(
              description: 'Dark theme for app',
              id: 'custom_dark_theme',
              data: ThemeData(
                  primaryColor: Colors.blue,
                  accentColor: Colors.blue[400],
                  textSelectionColor: Colors.blue[400],
                  textSelectionHandleColor: Colors.blue[400],
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  brightness: Brightness.dark,
                  appBarTheme: AppBarTheme(
                    color: Colors.grey[800],
                  ),
                  bottomAppBarTheme: BottomAppBarTheme(
                    color: Colors.grey[800],
                  ),
                  bottomAppBarColor: Colors.grey[800],
              ),
            ),
          ],
          onInitCallback: (controller, previouslySavedThemeFuture) async {
            // Do some other task here if you need to
            String savedTheme = await previouslySavedThemeFuture;
            if (savedTheme != null) {
              controller.setTheme(savedTheme);
              if (savedTheme == 'custom_dark_theme'){
                  Provider.of<ValueNotifier<bool>>(context, listen: false).value = true;
              }
            }
          },
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider<LocalDatabase>(
                create: (context)=> LocalDatabase(),
              ),
              ChangeNotifierProvider<ValueNotifier<DateTime>>.value(
                value: ValueNotifier<DateTime>(DateTime.now()),
              ),

            ],
            child: ThemeConsumer(
              child: Builder(
                builder: (themeContext) => MaterialApp(
                  title: 'Daily Todo',
                  debugShowCheckedModeBanner: false,
                  color: Colors.white,
                  theme: ThemeProvider.themeOf(themeContext).data,
                  home: Wrapper(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
