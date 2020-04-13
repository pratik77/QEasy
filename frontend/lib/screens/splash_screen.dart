import 'package:covidpass/screens/dashboard.dart';
import 'package:covidpass/screens/login.dart';
import 'package:covidpass/utils/constants.dart';
import 'package:covidpass/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  Animation _curvedAnimation;
  AnimationController _controller;
  double _angle = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _controller,
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _animation = Tween(begin: 200.0, end: 250.0).animate(_curvedAnimation)
      ..addListener(() {
        setState(() {
          _angle = _animation.value;
        });
      });
    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => SharedPrefUtils.get(Constants.USER_ID) != null
                ? Dashboard()
                : Login(),
          ),
          (route) => false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: _angle,
          height: _angle,
          child: SvgPicture.asset(
            "assets/vectors/splash_logo.svg",
            semanticsLabel: "Covid Pass",
          ),
        ),
      ),
    );
  }
}
