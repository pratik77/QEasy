import 'package:covidpass/repository/data_repository.dart';
import 'package:covidpass/screens/dashboard.dart';
import 'package:covidpass/screens/signup.dart';
import 'package:covidpass/utils/code_snippets.dart';
import 'package:covidpass/utils/colors.dart';
import 'package:covidpass/utils/constants.dart';
import 'package:covidpass/utils/form_validation.dart';
import 'package:covidpass/utils/keyboard_utils.dart';
import 'package:covidpass/utils/location_utils.dart';
import 'package:covidpass/utils/shared_pref.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TapGestureRecognizer _registerRecognizer = TapGestureRecognizer();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    _registerRecognizer.onTap = () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignUp(),
          ),
        );
    super.initState();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    _registerRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => KeyboardUtils.hideKeyboard(context),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: PrimaryDarkColor,
        body: Column(
          children: <Widget>[
            Flexible(
              child: Container(
                child: ListView(
                  children: <Widget>[
                    Image.asset("assets/clip_waiting.png"),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Welcome back to QEasy",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Sign in to continue",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              flex: 3,
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        controller: _mobileController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Phone Number",
                        ),
                        validator: (value) =>
                            FormValidation.validatePhone(value),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password",
                        ),
                        validator: (value) =>
                            FormValidation.validatePassword(value),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: PrimaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: FlatButton(
                          child: Text(
                            "SIGN IN",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () => login(),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "New User? ",
                              style: TextStyle(
                                color: PrimaryTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              recognizer: _registerRecognizer,
                              text: "REGISTER",
                              style: TextStyle(
                                color: PrimaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(CodeSnippets.makeSnackBar(message));
  }

  login() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (SharedPrefUtils.get(Constants.LAT) == null &&
        SharedPrefUtils.get(Constants.LONG) == null) {
      LocationData locationData = await LocationUtils.getCurrentLocation();
      if (locationData == null) {
        _showSnackBar("Location is needed to serve you better");
        return;
      }
    }
    DataRepository.instance
        .login(_mobileController.text, _passwordController.text)
        .then((response) {
      if (response.responseCode == "200") {
        SharedPrefUtils.setInt(Constants.USER_ID, response.data["userId"]);
        SharedPrefUtils.setString(Constants.USER_TYPE, response.data["role"]);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          (route) => false,
        );
      } else {
        _showSnackBar("Login Failed");
      }
      print(response.toJson());
    }).catchError((DioError error) {
      _showSnackBar("Login Failed: ${error.response.statusCode}");
    });
  }
}
