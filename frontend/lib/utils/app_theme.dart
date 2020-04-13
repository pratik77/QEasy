import 'package:covidpass/utils/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData buildTheme() {
    final base = ThemeData.light();
    return base.copyWith(
        primaryColor: PrimaryDarkColor,
        primaryColorDark: PrimaryColor,
        accentColor: AccentColor,
        buttonTheme: base.buttonTheme.copyWith(
          buttonColor: PrimaryColor,
          textTheme: ButtonTextTheme.primary,
          height: 55.0,
        ),
        scaffoldBackgroundColor: BackgroundColor,
        cardColor: ProgressBackgroundColor,
        textSelectionColor: AccentColor.withOpacity(0.5),
        errorColor: ErrorColor,
        textTheme: _buildTextTheme(base.textTheme),
        primaryTextTheme: _buildTextTheme(
          base.primaryTextTheme,
        ),
        accentTextTheme: _buildTextTheme(
          base.accentTextTheme,
        ),
        primaryIconTheme: base.iconTheme.copyWith(
          color: IconColor,
        ));
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return base
        .copyWith(
            headline: base.headline.copyWith(
              fontWeight: FontWeight.w600,
            ),
            title: base.title.copyWith(fontSize: 18.0),
            caption: base.caption.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
            ))
        .apply(
          fontFamily: 'DmSans',
          displayColor: PrimaryTextColor,
          bodyColor: PrimaryTextColor,
        );
  }
}
