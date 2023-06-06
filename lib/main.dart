import 'package:flutter/material.dart';

import './utils/constants.dart';
import './pages/home_page.dart';
import './utils/app_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.mainTheme,
      title: Constants.appName,
      home: const HomePage(),
    );
  }
}