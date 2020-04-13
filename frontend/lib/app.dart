import 'package:covidpass/screens/splash_screen.dart';
import 'package:covidpass/utils/app_theme.dart';
import 'package:covidpass/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class CovidPassApp extends StatefulWidget {
  @override
  _CovidPassAppState createState() => _CovidPassAppState();
}

class _CovidPassAppState extends State<CovidPassApp> {
  @override
  void initState() {
    SharedPrefUtils.init();
    super.initState();
  }

  @override
  void dispose() {
    SharedPrefUtils.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toodle',
      theme: AppTheme.buildTheme(),
      home: SplashScreen(),
    );
  }
}
