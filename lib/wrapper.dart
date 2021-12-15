import 'package:dailytodo/Screens/home_screen.dart';
import 'package:dailytodo/Screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  void selectScreen() async {
    setState(() {
      setVisitingValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getVisitingValue(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            return HomeScreen();
          } else {
            return WelcomeScreen(
              selectScreen: selectScreen,
            );
          }
        } else {
          return Scaffold();
        }
      },
    );
  }
}

Future<bool> getVisitingValue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('visitValue') ?? false;
}

setVisitingValue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('visitValue', true);
}
