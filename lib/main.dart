import 'package:scanbrew/Pages/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xff5f3c1e), // Pastel coffee colo
        appBarTheme: const AppBarTheme(
          color: Colors.transparent, // Set the app bar color to transparent
        ),
      ),
      home: const Login(),
      title: 'Scan Brew',
      debugShowCheckedModeBanner: false,
    );
  }
}
