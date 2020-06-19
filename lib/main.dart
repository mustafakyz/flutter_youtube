

import 'package:flutter/material.dart';
import 'package:proje1/views/main.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
    Widget build(BuildContext context) {
      return MaterialApp(
        initialRoute: '/',
            routes: {
               "/":(context)=>MainScreen(),
            },
      );
    }
}



