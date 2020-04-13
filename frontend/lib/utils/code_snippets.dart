import 'package:flutter/material.dart';

class CodeSnippets {
  static makeSnackBar(String message,
      {SnackBarAction action, Color backgroundColor}) {
    return SnackBar(
      backgroundColor:
          backgroundColor ?? ThemeData().snackBarTheme.backgroundColor,
      content: Text(message),
    );
  }
}
