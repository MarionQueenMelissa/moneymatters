import 'package:flutter/material.dart';
import 'package:money_matters_v3/src/screens/login.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Matters',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber,
        colorScheme: ColorScheme.highContrastDark(
            primary: Colors.amber,
            secondary: Colors.amberAccent,
            background: Colors.amberAccent),
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
