import 'package:covidpass/utils/colors.dart';
import 'package:flutter/material.dart';

class ShadowCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final double cornerRadius;

  ShadowCard({this.child, this.color, this.cornerRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? CardColor,
        borderRadius: BorderRadius.circular(cornerRadius ?? 4),
        boxShadow: [
          BoxShadow(
            color: CardShadowColor.withOpacity(0.5),
            blurRadius: 3.5,
            spreadRadius: 1.5,
          )
        ],
      ),
      child: child,
    );
  }
}
