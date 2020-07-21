import 'package:dailytodo/LocalDatabase/LocalDatabase.dart';
import 'package:dailytodo/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocalDatabase>(
          create: (context)=> LocalDatabase(),
        ),
        ChangeNotifierProvider<ValueNotifier<DateTime>>.value(
          value: ValueNotifier<DateTime>(DateTime.now()),
        )
      ],
      child: MaterialApp(
          title: 'Daily Todo',
          debugShowCheckedModeBanner: false,
          color: Colors.white,
          theme: ThemeData(
            primaryColor: Colors.blueAccent,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Wrapper(),
      ),
    );

  }
}
