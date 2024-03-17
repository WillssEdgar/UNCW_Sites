import 'package:csc315_team_edgar_burgess_project/Screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'UNCW Info App',
      home: HomeScreen(),
    );
  }
}
