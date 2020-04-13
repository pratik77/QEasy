import 'package:flutter/cupertino.dart';

class KeyboardUtils {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
